
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
        with nogil:
            self.thisptr.write(path)
    def resize(self, size):
        cdef magickGeometry geo = to_magickGeometry(size)
        with nogil:
            self.thisptr.resize(geo)
            
    def extent(self, string size, string gravity = "center"):
        gravity_value = GravityTypes[gravity.lower()]
        cdef magickGeometry geo = to_magickGeometry(size)
        cdef magickGravityType grav = gravity_value
        with nogil:
            self.thisptr.extent(geo, grav)
 
    def rotate(self,double degrees):
        with nogil:
            self.thisptr.rotate(degrees)
    def display(self):
        self.thisptr.display()
        
    def tostring(self):
        """
        matched from PythonMagick helpers_src, seems to work...
        const char* data = static_cast<const char*>(blob.data());
        size_t length = blob.length();
        return std::string(data,length);
        """
        
        cdef magickBlob blob
        cdef string data
        with nogil:
            blob = magickBlob()
            self.thisptr.write(&blob)
            data = string(<char*> blob.data(), blob.length())
           
        return data
    
    def fromstring(self, string data):
        
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
        def __get__(self):
            color = self.thisptr.backgroundColor()
            return toColor(color)
        def __set__(self, color):
            c = tomagickColor(color)
            self.thisptr.backgroundColor(c) 
            
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
            with nogil:
                self.thisptr.colorSpace(value)
            
    property filter:
        def __get__(self):
            return _value_lookup(FilterTypes,self.thisptr.filterType())
        def __set__(self, string filter):
            cdef magickFilterType value = FilterTypes[filter.lower()]
            self.thisptr.filterType(value)
