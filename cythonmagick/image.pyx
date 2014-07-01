
from libcpp.string cimport string
from libcpp cimport bool
from cython.operator cimport dereference as deref

cimport cython
from cpython cimport PyBuffer_FillInfo
from libc.stdlib cimport malloc, free

from magick.image cimport Image as magickImage
from magick.image cimport InitializeMagick
from magick.geometry cimport Geometry as magickGeometry
from magick.color cimport Color as magickColor
from magick.blob cimport Blob as magickBlob
from magick.coderinfo cimport CoderInfo as magickCoderInfo

from magick.gravity cimport GravityType as magickGravityType 
from magick.filter cimport FilterTypes as magickFilterType
from magick.compress cimport CompressionType as magickCompressionType
from magick.colorspace cimport ColorspaceType as magickColorspaceType
from magick.imagetype cimport ImageType as magickImageType
from magick.composite cimport CompositeOperator as magickCompositeOperator
cimport magick.imagetype

import os

def initialize():
    InitializeMagick(NULL)

def _value_lookup(d,v):
    for key,value in d.items():
        if value == v:
            return key

cdef dict StorageTypes = {'char': magick.imagetype.CharPixel,
                          'short': magick.imagetype.ShortPixel,
                          'int' : magick.imagetype.IntegerPixel,
                          'float': magick.imagetype.FloatPixel,
                          'double': magick.imagetype.DoublePixel}

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
    def __init__(self, path = None):
        cdef string s
        cdef magickGeometry geo = magickGeometry("0x0")
        color = to_magickColor("black")
        if path:
            s = path
            with nogil:
                self.thisptr = magickImage(s)
        else:
            with nogil:
                self.thisptr = magickImage(geo,color)
                
    @cython.boundscheck(False)  
    @cython.wraparound(False)      
    def fromrawbuffer(self, const unsigned char[::1] view, 
                      size_t width, size_t height, 
                      bytes pix_fmt, bytes dtype):
        
        
        cdef magick.imagetype.StorageType _dtype
        
        _dtype = StorageTypes[dtype.lower()]
        
        cdef string _pix_fmt = pix_fmt
        
        with nogil:
            self.thisptr.read(width, height, _pix_fmt, _dtype, &view[0])
            
    def frombuffer(self, object[unsigned char, ndim=1] data):
        
        """Construct Image by reading from encoded image data contained in string.
        """
        
        cdef magickBlob blob = magickBlob()

        cdef char * ptr = <char*> &data[0]
        cdef size_t size = len(data)
        with nogil:
            blob.update(<void*> ptr, size)
            
        self.thisptr.read(blob)
            
    def tostring(self):
        
        """Write image to a string. returns a string
        """
        
        cdef magickBlob blob
        cdef string data
        
        with nogil:
            blob = magickBlob()
            self.thisptr.write(&blob)
            data = string(<char*> blob.data(), blob.length())
           
        return data
    
    def tobuffer(self):
        cdef Blob blob = Blob.__new__(Blob)
        
        with nogil:
            self.thisptr.write(&blob.ptr)
        
        return blob
    
    def torawbuffer(self,size_t x, size_t y, size_t width, size_t height, bytes pix_fmt, bytes dtype):
        cdef magick.imagetype.StorageType _dtype
        
        _dtype = StorageTypes[dtype.lower()]
        
        cdef string _pix_fmt = pix_fmt
        
        cdef size_t size = width  * height * len(pix_fmt)
        
        if _dtype == magick.imagetype.CharPixel:
            size *= sizeof(unsigned char)
        elif _dtype == magick.imagetype.ShortPixel:
            size *= sizeof(unsigned short)
        elif _dtype == magick.imagetype.IntegerPixel:
            size *= sizeof(unsigned int)
        elif _dtype == magick.imagetype.FloatPixel:
            size *= sizeof(float)
        elif _dtype == magick.imagetype.DoublePixel:
            size *= sizeof(double)
        
        cdef Blob blob_obj = Blob.__new__(Blob)

        cdef unsigned char * data = <unsigned char *> malloc(size)
        if not data:
            raise MemoryError()
        
        try:
            self.thisptr.write(x,y , width, height, _pix_fmt, _dtype, <void *> data)
            blob_obj.ptr.updateNoCopy(data, size)
            return blob_obj
        except:
            free(data)
            raise

    def into_rawbuffer(self, const unsigned char[::1] view,
                           size_t x, size_t y, size_t width, size_t height, bytes pix_fmt, bytes dtype):
        
        cdef magick.imagetype.StorageType _dtype
        
        _dtype = StorageTypes[dtype.lower()]
        
        cdef string _pix_fmt = pix_fmt
        
        cdef size_t size = width  * height * len(pix_fmt)
        
        if _dtype == magick.imagetype.CharPixel:
            size *= sizeof(unsigned char)
        elif _dtype == magick.imagetype.ShortPixel:
            size *= sizeof(unsigned short)
        elif _dtype == magick.imagetype.IntegerPixel:
            size *= sizeof(unsigned int)
        elif _dtype == magick.imagetype.FloatPixel:
            size *= sizeof(float)
        elif _dtype == magick.imagetype.DoublePixel:
            size *= sizeof(double)
            
        if len(view) < size:
            raise BufferError("Buffer too small")
        
        with nogil:
            self.thisptr.write(x,y , width, height, _pix_fmt, _dtype, <void *> &view[0])
    
    
    def write(self, bytes path):
        
        """Write image to a file using filename path.
        """
        
        if not os.path.exists(os.path.abspath(os.path.dirname(path))):
            raise IOError("ouput directory does not exist %s" % path)
        
        cdef string s_path = path
        
        with nogil:
            self.thisptr.write(s_path)
            
    ##Image Image Manipulation Methods
    
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
            
    def composite(self, Image image, string compose = "in", offset=None, gravity=None):
        
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
        
            
    def resize(self, size):
        
        """Resize image to specified size.
        size can be a string (e.g. "640x480) or a Geometry object
        """
        
        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.resize(geo)
 
    def rotate(self,double degrees):
        
        """Rotate image counter-clockwise by specified number of degrees.
        """
        
        with nogil:
            self.thisptr.rotate(degrees)
            
    ##Image Attributes
        
    def size(self):
        
        """returns a Geometry object that represents the image dimensions
        """
        
        geo = self.thisptr.size()
 
        return toGeometry(geo)
    
    def __getitem__(self, bytes key):
        
        return self.thisptr.attribute(key)
    
    def __setitem__(self, bytes key, bytes value):
        self.thisptr.artifact(key, value)
        self.thisptr.attribute(key, value)

    property background:
    
        """Image background color
        """
    
        def __get__(self):
            color = self.thisptr.backgroundColor()
            return toColor(color)
        def __set__(self, color):
            c = to_magickColor(color)
            self.thisptr.backgroundColor(c) 
            
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
            
    property quality:
    
        """JPEG/MIFF/PNG compression level (default 75).
        """
        
        def __get__(self):
            return self.thisptr.quality()
        def __set__(self,size_t value):
            self.thisptr.quality(value)
            
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
            
