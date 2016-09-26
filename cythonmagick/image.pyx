
from libcpp.string cimport string
from libcpp cimport bool
from libcpp.list cimport list as cpplist
from cython.operator cimport dereference as deref, preincrement as inc

cimport cython
from cython.view cimport array as cvarray

from cpython cimport PyBuffer_FillInfo
from libc.stdlib cimport malloc, free

cimport image as magick
from image cimport Image as magickImage
from image cimport InitializeMagick
from image cimport PixelPacket as magickPixelPacket
from geometry cimport Geometry as magickGeometry
from color cimport Color as magickColor
from color cimport  ColorRGB as magickColorRGB
from blob cimport Blob as magickBlob
from coderinfo cimport CoderInfo as magickCoderInfo

from gravity cimport GravityType as magickGravityType
from filter cimport FilterTypes as magickFilterType

from channel cimport ChannelType as magickChannelType
from compress cimport CompressionType as magickCompressionType
from colorspace cimport ColorspaceType as magickColorspaceType
from imagetype cimport ImageType as magickImageType
from imagetype cimport ClassType as magickClassType
from composite cimport CompositeOperator as magickCompositeOperator
cimport imagetype
cimport magickcore
cimport stl

import os

def initialize():
    InitializeMagick(NULL)

initialize()

def _value_lookup(d,v):
    for key,value in d.items():
        if value == v:
            return key

cdef dict StorageTypes = {'char': imagetype.CharPixel,
                          'short': imagetype.ShortPixel,
                          'int' : imagetype.IntegerPixel,
                          'float': imagetype.FloatPixel,
                          'double': imagetype.DoublePixel}

def pixel_byte_size(str dtype):
    cdef imagetype.StorageType _dtype

    _dtype = StorageTypes[dtype.lower()]

    cdef size_t size

    if _dtype == imagetype.CharPixel:
        size = sizeof(unsigned char)
    elif _dtype == imagetype.ShortPixel:
        size = sizeof(unsigned short)
    elif _dtype == imagetype.IntegerPixel:
        size = sizeof(unsigned int)
    elif _dtype == imagetype.FloatPixel:
        size = sizeof(float)
    elif _dtype == imagetype.DoublePixel:
        size = sizeof(double)

    return int(size)

cdef class Blob(object):
    cdef magickBlob ptr

    def __cinit__(self, buffer=None):
        self.ptr = magickBlob()

    def __getbuffer__(self, Py_buffer *view, int flags):
        # has except -1, cython will raise exception for you
        PyBuffer_FillInfo(view, self, <void*>self.ptr.data(),
                          self.ptr.length(), 0, flags)

cdef class Image(object):
    cdef magickImage thisptr
    def __init__(self, path = None, size=None, color=None):
        cdef string s
        cdef Blob blob
        cdef magickGeometry geo
        cdef magickColorRGB _color
        if size:
            geo =to_magickGeometry(size)
        else:
            geo = magickGeometry("0x0")

        if color:
            c = to_magickColor(color)
        else:
            c = to_magickColor("black")

        if isinstance(path, str):
            s = path
            with nogil:
                self.thisptr = magickImage(s)

        elif isinstance(path, Blob):
            blob = path
            with nogil:
                self.thisptr = magickImage(blob.ptr)
        else:
            with nogil:
                self.thisptr = magickImage(geo, c)

    def fromstring(self, bytes data):

        """Construct Image by reading from encoded image data contained in string.
        """

        cdef magickBlob blob = magickBlob()

        cdef char *ptr = data
        cdef size_t size = len(data)
        with nogil:
            blob.update(<void*> ptr, size)
            self.thisptr.read(blob)

    def tostring(self):

        """Write image to a string. returns a string
        """

        cdef magickBlob blob = magickBlob()
        cdef char *ptr

        with nogil:
            self.thisptr.write(&blob)
        ptr = <char*> blob.data()

        return ptr[:blob.length()]

    def tobuffer(self):
        cdef Blob blob = Blob.__new__(Blob)

        with nogil:
            self.thisptr.write(&blob.ptr)

        return blob

    @cython.boundscheck(False)
    @cython.wraparound(False)
    def from_rawbuffer(self, const unsigned char[::1] view,
                      size_t width, size_t height,
                      bytes pix_fmt, bytes dtype):


        cdef imagetype.StorageType _dtype

        _dtype = StorageTypes[dtype.lower()]

        cdef string _pix_fmt = pix_fmt

        cdef size_t size = width  * height * len(pix_fmt) * pixel_byte_size(dtype)

        if len(view) < size:
            raise BufferError("Buffer too small")

        with nogil:
            self.thisptr.read(width, height, _pix_fmt, _dtype, &view[0])

    @cython.boundscheck(False)
    @cython.wraparound(False)
    def from_YCbCr444_rawbuffer(self, const unsigned char[::1] y_view,
                                      const unsigned char[::1] cb_view,
                                      const unsigned char[::1] cr_view,
                                      size_t width, size_t height):

        buffer_len = width * height * sizeof(unsigned short)
        assert len(y_view) == buffer_len
        assert len(cb_view) == buffer_len
        assert len(cr_view) == buffer_len

        cdef unsigned short *y_ptr = <unsigned short *> &y_view[0]
        cdef unsigned short *cb_ptr = <unsigned short *> &cb_view[0]
        cdef unsigned short *cr_ptr = <unsigned short *> &cr_view[0]


        cdef int p = 0

        cdef double Y = 0
        cdef double Cb = 0
        cdef double Cr = 0

        cdef double R = 0
        cdef double G = 0
        cdef double B = 0

        cdef string pix_fmt = 'rgb'

        cdef size_t length = width*height*3 * sizeof(double)
        cdef double *data = <double *> malloc(length)
        if data is NULL:
            raise MemoryError()

        try:
            with nogil:

                for i in xrange(width*height):

                    Y =  (y_ptr[i]  / 65535.0) * 256.0 # why does this need to be 256 ? this makes it match output from nuke
                    Cb = (cb_ptr[i] / 65535.0) * 256.0
                    Cr = (cr_ptr[i] / 65535.0) * 256.0

                    # ITU.BT-709 0.0 - 255.0 range
                    R = ( (1.164 *(Y-16.0)) + (1.793 * (Cr - 128.0) ) ) / 255.0
                    G = ( (1.164 *(Y-16.0)) - (0.534 * (Cr - 128.0) ) - (0.213 * (Cb - 128.0) ) ) / 255.0
                    B = ( (1.164 *(Y-16.0)) + (2.115 * (Cb - 128.0) ) ) / 255.0

                    data[p] = R
                    p+= 1
                    data[p] = G
                    p+= 1
                    data[p] = B
                    p+= 1

                self.thisptr.read(width, height, pix_fmt, imagetype.DoublePixel, data)
        finally:
            free(data)

    @cython.boundscheck(False)
    @cython.wraparound(False)
    def into_YCbCr444p16_buffer(self, const unsigned char[::1] y_view,
                                      const unsigned char[::1] cb_view,
                                      const unsigned char[::1] cr_view):

        cdef size_t width = self.width
        cdef size_t height = self.height

        cdef int i = 0
        cdef const magickPixelPacket *pixels = NULL
        cdef magickColorRGB color

        cdef double Y = 0
        cdef double Cb = 0
        cdef double Cr = 0

        cdef double R = 0
        cdef double G = 0
        cdef double B = 0

        cdef double Kb = 0.0722
        cdef double Kr = 0.2126

        buffer_len = width * height * sizeof(unsigned short)
        assert len(y_view) == buffer_len
        assert len(cb_view) == buffer_len
        assert len(cr_view) == buffer_len

        cdef unsigned short *y_ptr = <unsigned short *> &y_view[0]
        cdef unsigned short *cb_ptr = <unsigned short *> &cb_view[0]
        cdef unsigned short *cr_ptr = <unsigned short *> &cr_view[0]

        with nogil:
            pixels = self.thisptr.getConstPixels(0, 0, width, height)

            for i in range(width*height):
                color = <magickColorRGB>pixels[i]
                R = color.red()
                G = color.green()
                B = color.blue()

                Y = (Kr * R) + ((1-Kr-Kb) * G) + (Kb * B)
                Cb = 0.5 + (0.5 * ( (B-Y)/(1-Kb) ) )
                Cr = 0.5 + (0.5 * ( (R-Y)/(1-Kr) ) )

                # Scaling
                Y  = (16.0/256.0 + (Y  * (235.0 - 16.0)/256.0))
                Cb = (16.0/256.0 + (Cb * (240.0 - 16.0)/256.0))
                Cr = (16.0/256.0 + (Cr * (240.0 - 16.0)/256.0))

                y_ptr[i] = <unsigned short> (Y * 65535.0)
                cb_ptr[i] = <unsigned short> (Cb * 65535.0)
                cr_ptr[i] = <unsigned short> (Cr * 65535.0)

    @cython.boundscheck(False)
    @cython.wraparound(False)
    def into_rawbuffer(self, const unsigned char[::1] view,
                           size_t x, size_t y, size_t width, size_t height, bytes pix_fmt, bytes dtype):

        cdef imagetype.StorageType _dtype

        _dtype = StorageTypes[dtype.lower()]

        cdef string _pix_fmt = pix_fmt

        cdef size_t size = width  * height * len(pix_fmt)  * pixel_byte_size(dtype)

        if len(view) < size:
            raise BufferError("Buffer too small")

        with nogil:
            self.thisptr.write(x,y , width, height, _pix_fmt, _dtype, <void *> &view[0])

    def read(self, string path):
        with nogil:
            self.thisptr.read(path)

    def write(self, bytes path):

        """Write image to a file using filename path.
        """

        if not os.path.exists(os.path.abspath(os.path.dirname(path))):
            raise IOError("ouput directory does not exist %s" % path)

        cdef string s_path = path

        with nogil:
            self.thisptr.write(s_path)

    ##Image Image Manipulation Methods

    def annotate(self, string text, bounding_area=None, gravity = "center", double rotation =0):

        cdef magickGeometry bounding_geo
        cdef magickGravityType gravity_type

        if bounding_area:
            bounding_geo = to_magickGeometry(bounding_area)
        else:
            bounding_geo = self.thisptr.size()

        gravity_type = GravityTypes[gravity.lower()]

        with nogil:
            self.thisptr. annotate(text, bounding_geo, gravity_type, rotation)


    def compare(self, Image image):

        """Compare current image with another image.
        True is returned if the images are identical
        """

        cdef bool result
        try:
            with nogil:
                result = self.thisptr.compare(image.thisptr)
        except:
            return False

        return result

    def composite(self, Image image, string compose = "over", offset=None, gravity=None):

        """Compose an image onto the current image using the composition algorithm specified by compose.
        The CompositeOperators available in cythonmagick.CompositeOperators.keys().
        If offset is specified the composed image will be offset, gravity will be ignored.
        If gravity is specified the image will be composed using gravity.
        If gravity and offset are both None there will be no offset.
        """

        cdef magickCompositeOperator compose_ = CompositeOperators[compose]
        cdef magickGravityType gravity_
        cdef magickGeometry geo

        if offset:
            geo = to_magickGeometry(offset)
            with nogil:
                self.thisptr.composite(image.thisptr, geo,compose_)
        elif gravity:
            gravity_ = GravityTypes[gravity.lower()]
            with nogil:
                self.thisptr.composite(image.thisptr, gravity_, compose_)
        else:
            geo = to_magickGeometry("0x0")
            with nogil:
                self.thisptr.composite(image.thisptr, geo, compose_)

    def crop(self,size):

        """Crops image to specified size.
        size can be a string (e.g. "640x480) or a Geometry object
        """

        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.crop(geo)

    def display(self):
        self.thisptr.display()

    def copy(self):
        cdef Image i = Image.__new__(Image)

        i.thisptr = self.thisptr
        return i

    def erase(self):
        self.thisptr.erase()

    def channel(self, string channel_type):
        cdef magickChannelType channel_type_ = ChannelTypes[channel_type.lower()]
        cdef Image copy = self.copy()

        copy.thisptr.channel(channel_type_)
        return copy

    def extent(self, size, string gravity = "center"):

        """extends the image as defined by the geometry and gravity.
        size can be a string (e.g. "640x480) or a Geometry object
        """

        gravity_value = GravityTypes[gravity.lower()]
        cdef magickGeometry geo = to_magickGeometry(size)
        cdef magickGravityType grav = gravity_value
        with nogil:
            self.thisptr.extent(geo, grav)

    def flip(self):

        """Flip image (reflect each scanline in the vertical direction)
        """

        with nogil:
            self.thisptr.flip()

    def flop(self):

        """Flop image (reflect each scanline in the horizontal direction)
        """

        with nogil:
            self.thisptr.flop()

    def gamma(self,double value):

        """Gamma correct image (uniform red, green, and blue correction).
        """

        with nogil:
            self.thisptr.gamma(value)

    def haldclut(self, Image image):

        """apply a Hald color lookup table to the image.
        """

        with nogil:
            self.thisptr.haldClut(image.thisptr)

    def negate(self, bool grayscale = False):

        with nogil:
            self.thisptr.negate(grayscale)

    def clamp(self):
        with nogil:
            self.thisptr.clamp()

    def resize(self, size):

        """Resize image to specified size.
        size can be a string (e.g. "640x480) or a Geometry object
        """

        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.resize(geo)

    def distort(self, string distort_method, args, bool bestfit=False):
        cdef filter.DistortImageMethod method = DistortImageMethods[distort_method.lower()]

        cdef list arg_list = list(args)
        cdef size_t nb_args = len(arg_list)
        cdef double[:] double_list = cvarray(shape=(len(arg_list),),
                                             itemsize=sizeof(double), format="d")
        for i, item in enumerate(arg_list):
            double_list[i] = item

        with nogil:
            self.thisptr.distort(method, nb_args, &double_list[0], bestfit)

    def scale(self, size):
        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.scale(geo)

    def rotate(self,double degrees):

        """Rotate image counter-clockwise by specified number of degrees.
        """

        with nogil:
            self.thisptr.rotate(degrees)

    def set_define_value(self, string magick, string key, string value):
        self.thisptr.defineValue(magick, key, value)

    def get_define_value(self, string magick, string key):
        return self.thisptr.defineValue(magick, key)

    def set_define_flag(self, string magick, string key, bool flag):
        self.thisptr.defineSet(magick, key, flag)

    def get_define_flag(self, string magick, string key):
        return self.thisptr.defineSet(magick, key)

    ##Image Attributes

    def size(self):

        """returns a Geometry object that represents the image dimensions
        """
        geo = self.thisptr.size()
        return toGeometry(geo)

    def strip(self):
        self.thisptr.strip()

    def fx(self, string expression, string channel = "default"):
        """Applies a mathematical expression to the image
        """
        cdef magickChannelType channel_type = ChannelTypes[channel.lower()]
        with nogil:
            self.thisptr.fx(expression, channel_type)

    property attributes:
        def __get__(self):
            cdef Attributes attributes = Attributes.__new__(Attributes, self)
            return attributes

    IF MAGICKLIBVERSION >= 657:
        property artifacts:
            def __get__(self):
                cdef Artifacts artifacts = Artifacts.__new__(Artifacts, self)
                return artifacts

    property width:
        def __get__(self):
            return self.size().width

    property height:
        def __get__(self):
            return self.size().height

    property adjoin:
        def __get__(self):
            return self.thisptr.adjoin()

        def __set__(self, bool value):
            self.thisptr.adjoin(value)

    property background:

        """Image background color
        """

        def __get__(self):
            color = self.thisptr.backgroundColor()
            return toColor(color)
        def __set__(self, color):
            c = to_magickColor(color)
            self.thisptr.backgroundColor(c)

    property bounding_box:

        """ smallest bounding box enclosing non-border pixels
        """

        def __get__(self):
            cdef magickGeometry geo
            with nogil:
                geo = self.thisptr.boundingBox()
            return toGeometry(geo)

    property border:

        """Image border color
        """

        def __get__(self):
            color = self.thisptr.borderColor()
            return toColor(color)

        def __set__(self, color):
            c = to_magickColor(color)
            self.thisptr.borderColor(c)

    property colorspace:

        """The colorspace (e.g. log) used to represent the image pixel colors.
        """

        def __get__(self):
            return _value_lookup(ColorspaceTypes,self.thisptr.colorSpace())
        def __set__(self,string colorspace):
            cdef magickColorspaceType value = ColorspaceTypes[colorspace.lower()]
            with nogil:
                self.thisptr.colorSpace(value)

    property compress:

        """Image compresion type.
        The default is the compression type of the specified image file.
        """

        def __get__(self):
            return _value_lookup(CompressTypes, self.thisptr.compressType())
        def __set__(self, string compression):
            cdef magickCompressionType value = CompressTypes[compression.lower()]
            self.thisptr.compressType(value)

    property debug:

        """Enable printing of internal debug messages from ImageMagick as it executes.
        """

        def __get__(self):
            return self.thisptr.debug()
        def __set__(self, bool value):
            self.thisptr.debug(value)

    property depth:

        """Image depth.
        Used to specify the bit depth when reading or writing raw
        images or when the output format supports multiple depths.
        Defaults to the quantum depth that ImageMagick is compiled with.
        """

        def __get__(self):
            return self.thisptr.depth()
        def __set__(self,int depth):
            self.thisptr.depth(depth)

    property density:
        def __get__(self):
            return toGeometry(self.thisptr.density())
        def __set__(self, value):
            cdef magickGeometry geo = to_magickGeometry(value)
            with nogil:
                self.thisptr.density(geo)

    property filter:

        """Filter to use when resizing image.
        The reduction filter employed has a sigificant effect on the
        time required to resize an image and the resulting quality.
        The default filter is Lanczos which has been shown to produce
        high quality results when reducing most images.
        """

        def __get__(self):
            return _value_lookup(FilterTypes,self.thisptr.filterType())
        def __set__(self, string filter):
            cdef magickFilterType value = FilterTypes[filter.lower()]
            self.thisptr.filterType(value)

    property fuzz:

        """Colors within this distance are considered equal. A number of algorithms search for a target  color.
        By default the color must be exact. Use this option to match colors that are close to the target color in RGB space.
        """

        def __get__(self):
            return self.thisptr.colorFuzz()
        def __set__(self, double value):
            self.thisptr.colorFuzz(value)

    property box_color:

        """Base color that annotation text is rendered on.
        """

        def __get__(self):
            color = self.thisptr.boxColor()
            return toColor(color)
        def __set__(self, color):
            c = to_magickColor(color)
            self.thisptr.boxColor(c)

    property fill_color:
        """Color to use when filling drawn objects.
        """

        def __get__(self):
            color = self.thisptr.fillColor()
            return toColor(color)
        def __set__(self, color):
            c = to_magickColor(color)
            self.thisptr.fillColor(c)

    property font:
        def __get__(self):
            return self.thisptr.font()
        def __set__(self, string value):
            self.thisptr.font(value)

    property font_point_size:

        """text rendering font point size
        """

        def __get__(self):
            return self.thisptr.fontPointsize()
        def __set__(self, size_t value):
            self.thisptr.fontPointsize(value)

    property text_gravity:
        def __get__(self):
            cdef magickGravityType g = self.thisptr.textGravity()
            for key, value in GravityTypes.items():
                if value == g:
                    return key
        def __set__(self, value):
            cdef  magickGravityType g = GravityTypes[value.lower()]
            self.thisptr.textGravity(g)

    property matte:

        def __get__(self):
            return self.thisptr.matte()
        def __set__(self, bool value):
            self.thisptr.matte(value)

    property magick:

        """image format (e.g. "GIF")
        """

        def __get__(self):
            return self.thisptr.magick()
        def __set__(self,string magick):
            info = coderinfo(magick)
            if info['write']:
                with nogil:
                    self.thisptr.magick(magick)
            else:
                raise ValueError("%s format is not supported" % magick)

    property page:

        """Preferred size and location of an image canvas.
        """

        def __get__(self):
            geo = self.thisptr.page()
            return toGeometry(geo)

        def __set__(self, value):
            cdef magickGeometry geo = to_magickGeometry(value)
            with nogil:
                self.thisptr.page(geo)

    property quality:

        """JPEG/MIFF/PNG compression level (default 75).
        """

        def __get__(self):
            return self.thisptr.quality()
        def __set__(self,size_t value):
            self.thisptr.quality(value)

    property class_type:

        def __get__(self):
            return _value_lookup(ClassTypes,self.thisptr.classType())

        def __set__(self, string value):
            cdef magickClassType value_ = ClassTypes[value.lower()]
            self.thisptr.classType(value_)

    property type:

        """Image type
        """

        def __get__(self):
            return _value_lookup(ImageTypes,self.thisptr.type())
        def __set__(self,string imagetype):
            cdef magickImageType value = ImageTypes[imagetype.lower()]
            self.thisptr.type(value)

    property verbose:

        """Print detailed information about the image
        """

        def __get__(self):
            return self.thisptr.verbose()
        def __set__(self, bool value):
            self.thisptr.verbose(value)

cdef class Properties(object):
    cdef Image image
    def __cinit__(self, Image image):
        self.image =  image

    def __init__(self):
        raise TypeError("%s cannot be instantiated from Python" %  self.__class__.__name__)

    def keys(self):
        return list(self.iterkeys())

    def iteritems(self):
        for key in self.iterkeys():
            yield key, self[key]

    def items(self):
        return list(self.iteritems())

    def __len__(self):
        return len(self.key())

    def __contains__(self, x):
        for key in self.iterkeys():
            if key == x:
                return 1
        return 0

    def __repr__(self):
        return str(dict(self))

cdef class Attributes(Properties):
    def iterkeys(self):
        cdef const magickcore.Image *ptr = self.image.thisptr.constImage()
        magickcore.ResetImagePropertyIterator(ptr)
        cdef char *prop
        while True:
            prop = magickcore.GetNextImageProperty(ptr)
            if prop is NULL:
                break
            yield prop

    def __getitem__(self, bytes key):
        #return self.image.thisptr.attribute(key) or None
        cdef const magickcore.Image *ptr = self.image.thisptr.constImage()
        cdef const char* value = magickcore.GetImageProperty(ptr, key)

        if not value is NULL:
            return value
        return None

    def __setitem__(self, bytes key, bytes value):
        self.image.thisptr.attribute(key, value)

    def __delitem__(self, bytes key):
        cdef magickcore.MagickBooleanType result

        self.image.thisptr.modifyImage()

        cdef magickcore.Image *ptr = self.image.thisptr.image()

        result = magickcore.DeleteImageProperty(ptr, key)

        if result == magickcore.MagickFalse:
            raise RuntimeError("Unable to delete %s" % key)

IF MAGICKLIBVERSION >= 657:
    cdef class Artifacts(Properties):

        def iterkeys(self):
            cdef const magickcore.Image *ptr = self.image.thisptr.constImage()
            magickcore.ResetImageArtifactIterator(ptr)
            cdef char *prop
            while True:
                prop = magickcore.GetNextImageArtifact(ptr)
                if prop is NULL:
                    break
                yield prop

        def __getitem__(self, bytes key):
            cdef const magickcore.Image *ptr = self.image.thisptr.constImage()
            cdef const char* value = magickcore.GetImageArtifact(ptr, key)

            if not value is NULL:
                return value
            return None


        def __setitem__(self, bytes key, bytes value):
            cdef magickcore.MagickBooleanType result
            self.image.thisptr.modifyImage()
            cdef magickcore.Image *ptr = self.image.thisptr.image()

            result = magickcore.SetImageArtifact(ptr, key, value)

            if result == magickcore.MagickFalse:
                raise ValueError("Failed to set %s = %s" % (key, value))

        def __delitem__(self, bytes key):
            cdef magickcore.MagickBooleanType result
            self.image.thisptr.modifyImage()

            cdef magickcore.Image *ptr = self.image.thisptr.image()

            result = magickcore.DeleteImageArtifact(ptr, key)

            if result == magickcore.MagickFalse:
                raise RuntimeError("Unable to delete %s" % key)

def write_images(images, string dest, bool adjoin=True):

    cdef cpplist[magickImage] image_list;
    cdef Image image;

    for image in images:
        image_list.push_back(image.thisptr)

    stl.writeImages[cpplist[magickImage].iterator](image_list.begin(), image_list.end(), dest, adjoin)

def read_images(path):
    cdef cpplist[magickImage] image_list;
    cdef Image image;

    stl.readImages[cpplist[magickImage]](&image_list, path)

    images = []

    cdef cpplist[magickImage].iterator it = image_list.begin()

    while it != image_list.end():
        image = Image()
        image.thisptr = deref(it)
        images.append(image)
        inc(it)

    return images
