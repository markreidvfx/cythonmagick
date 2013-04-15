
from libcpp.string cimport string
from cython.operator cimport dereference as deref

cimport Image as _Image
cimport Geometry as _Geometry
cimport Colorspace as _Colorspace

def initialize():
    _Image.InitializeMagick("")
    
LogColorspace = _Colorspace.LogColorspace
GRAYColorspace = _Colorspace.GRAYColorspace

cdef class Image:
    cdef _Image.Image *thisptr

    def __cinit__(self, string path):
        self.thisptr = new _Image.Image(path)
    def write(self, string path):
        self.thisptr.write(path)
    def resize(self, string size):
        cdef _Geometry.Geometry *geo = new _Geometry.Geometry(size)

        try:
            self.thisptr.resize(deref(geo))
        finally:
            del geo

    def rotate(self,double degrees):
        self.thisptr.rotate(degrees)
    def display(self):
        self.thisptr.display()

    def colorspace(self,_Colorspace.ColorspaceType c_space):

        #c_space = _Colorspace.LogColorspace
        print "c_space", c_space
        
        self.thisptr.colorSpace(c_space)

    def test(self):
        print self.thisptr.colorSpace()

    def __dealloc__(self):
        del self.thisptr

