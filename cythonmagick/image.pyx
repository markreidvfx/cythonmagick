
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
        cdef magickGeometry *geo = new magickGeometry("0x0")
        cdef magickColor *color = new magickColor("black")
        if path:
            s = path
            self.thisptr = new magickImage(s)
        else:
            self.thisptr = new magickImage(deref(geo),deref(color))
            
        del geo
        del color
        
    def write(self, string path):
        self.thisptr.write(path)
    def resize(self, string size):
        cdef magickGeometry *geo = new magickGeometry(size)

        try:
            self.thisptr.resize(deref(geo))
        finally:
            del geo
            
    def extent(self, string size, string color_="transparent",string gravity = "center"):
        
        gravity_value = GravityTypes[gravity.lower()]
        
        cdef magickGeometry *geo = new magickGeometry(size)
        cdef magickColor *col = new magickColor(color_)
        cdef magickGravityType grav = gravity_value
        
        self.thisptr.extent(deref(geo), deref(col), grav)
        
        del geo
        del col

    def rotate(self,double degrees):
        self.thisptr.rotate(degrees)
    def display(self):
        self.thisptr.display()
        
    def tostring(self):
        """
        matched from PythonMagick helpers_src, seems to work...
        const char* data = static_cast<const char*>(blob.data());
        size_t length = blob.length();
        return std::string(data,data);
        """
        
        cdef magickBlob *blob = new magickBlob()

        self.thisptr.write(blob)
        
        s = string(<char*> blob.data(), blob.length())
        
        del blob
       
        return s
    
    def fromstring(self, string data):
        
        cdef magickBlob *blob = new magickBlob()
        
        blob.update(data.c_str(),data.size())
        
        del self.thisptr
        self.thisptr = new magickImage(deref(blob))
        
        del blob

    def __dealloc__(self):
        del self.thisptr
        
    def size(self):
        geo = self.thisptr.size()
        
        width = geo.width()
        height = geo.height()
        return (width,height)
        
    property magick:
        
        def __get__(self):
            return self.thisptr.magick()
            
        def __set__(self,string magick):
            
            info = coderinfo(magick)
            if info['write']:
            
                self.thisptr.magick(magick)
            else:
                raise ValueError("%s format is not supported" % magick)
            
    property depth:
        def __get__(self):
            return self.thisptr.depth()
        def __set__(self,int depth):
            self.thisptr.depth(depth)
            
    property compress:
        def __get__(self):
            return _value_lookup(CompressTypes, self.thisptr.compressType())
        def __set__(self, string compression):
            cdef magickCompressionType value = CompressTypes[compression.lower()]
            self.thisptr.compressType(value)
            
    property colorspace:
        def __get__(self):
            return _value_lookup(ColorspaceTypes,self.thisptr.colorSpace())
        def __set__(self,string colorspace):
            cdef magickColorspaceType value = ColorspaceTypes[colorspace.lower()]
            self.thisptr.colorSpace(value)
            
    property filter:
        def __get__(self):
            return _value_lookup(FilterTypes,self.thisptr.filterType())
        def __set__(self, string filter):
            cdef magickFilterType value = FilterTypes[filter.lower()]
            self.thisptr.filterType(value)
