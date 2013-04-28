
from libcpp.string cimport string
from cython.operator cimport dereference as deref

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

def initialize():
    InitializeMagick(NULL)

def _value_lookup(d,v):
    for key,value in d.items():
        if value == v:
            return key

cdef class Image:
    cdef magickImage *thisptr
    def __cinit__(self, path = None):
        cdef string s
        cdef magickGeometry geo = magickGeometry("0x0")
        color = tomagickColor("black")
        if path:
            s = path
            with nogil:
                self.thisptr = new magickImage(s)
        else:
            self.thisptr = new magickImage(geo,color)
        
    def write(self, string path):
        
        """Write image to a file using filename path.
        """
        
        with nogil:
            self.thisptr.write(path)
    def resize(self, size):
        
        """Resize image to specified size.
        """
        
        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.resize(geo)
            
    def extent(self, string size, string gravity = "center"):
        
        """extends the image as defined by the geometry and gravity.
        """
        
        gravity_value = GravityTypes[gravity.lower()]
        cdef magickGeometry geo = to_magickGeometry(size)
        cdef magickGravityType grav = gravity_value
        with nogil:
            self.thisptr.extent(geo, grav)
 
    def rotate(self,double degrees):
        
        """Rotate image counter-clockwise by specified number of degrees.
        """
        
        with nogil:
            self.thisptr.rotate(degrees)
    def display(self):
        self.thisptr.display()
        
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
    
    def fromstring(self, string data):
        
        """Construct Image by reading from encoded image data contained in string.
        """
        
        cdef magickBlob blob = magickBlob()
        with nogil:
            blob.update(data.c_str(),data.size())
            del self.thisptr
            self.thisptr = new magickImage(blob)

    def __dealloc__(self):
        if self.thisptr is not NULL:
            del self.thisptr
        
    def size(self):
        geo = self.thisptr.size()
 
        return toGeometry(geo)
        
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
            
    property background:
    
        """Image background color
        """
    
        def __get__(self):
            color = self.thisptr.backgroundColor()
            return toColor(color)
        def __set__(self, color):
            c = tomagickColor(color)
            self.thisptr.backgroundColor(c) 
            
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
            
    property compress:
    
        """Image compresion type. 
        The default is the compression type of the specified image file.
        """
        
        def __get__(self):
            return _value_lookup(CompressTypes, self.thisptr.compressType())
        def __set__(self, string compression):
            cdef magickCompressionType value = CompressTypes[compression.lower()]
            self.thisptr.compressType(value)
            
    property colorspace:
    
        """The colorspace (e.g. log) used to represent the image pixel colors.
        """
        
        def __get__(self):
            return _value_lookup(ColorspaceTypes,self.thisptr.colorSpace())
        def __set__(self,string colorspace):
            cdef magickColorspaceType value = ColorspaceTypes[colorspace.lower()]
            with nogil:
                self.thisptr.colorSpace(value)
            
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
