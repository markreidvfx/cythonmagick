
from libcpp.string cimport string
from cython.operator cimport dereference as deref

from magick.image cimport Image as magickImage
from magick.image cimport InitializeMagick
from magick.geometry cimport Geometry as magickGeometry

from magick.colorspace cimport ColorspaceType
from magick.compress cimport CompressionType

def initialize():
    InitializeMagick(NULL)


cdef class Image:
    cdef magickImage *thisptr

    def __cinit__(self, string path):
        self.thisptr = new magickImage(path)
    def write(self, string path):
        self.thisptr.write(path)
    def resize(self, string size):
        cdef magickGeometry *geo = new magickGeometry(size)

        try:
            self.thisptr.resize(deref(geo))
        finally:
            del geo

    def rotate(self,double degrees):
        self.thisptr.rotate(degrees)
    def display(self):
        self.thisptr.display()

    def compressType(self):
        return self.thisptr.compressType()
        
    def setCompressType(self,CompressionType compress):
        self.thisptr.compressType(compress)

    def test(self):
        print self.thisptr.colorSpace()

    def __dealloc__(self):
        del self.thisptr
        
    property magick:
        
        def __get__(self):
            return self.thisptr.magick()
            
        def __set__(self,string magick_):
            self.thisptr.magick(magick_)
    property colorspace:
        
        def __get__(self):
        
            colorspace_ = self.thisptr.colorSpace()
            
            for key,value in colorspaceTypes.items():
                if value == colorspace_:
                    return key
            
            return colorspace_
            
        def __set__(self,string colorspace_):
        
            c_space = self.thisptr.colorSpace()
            
            for key,value in colorspaceTypes.items():
                if key.lower() == colorspace_.lower():
                    c_space = value
            
            self.thisptr.colorSpace(c_space)

