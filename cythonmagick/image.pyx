
from libcpp.string cimport string
from cython.operator cimport dereference as deref

from magick.image cimport Image as magickImage
from magick.image cimport InitializeMagick
from magick.geometry cimport Geometry as magickGeometry

cimport magick.Colorspace


def initialize():
    InitializeMagick("")


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

    def colorspace(self,magick.Colorspace.ColorspaceType c_space):

        #c_space = _Colorspace.LogColorspace
        print "c_space", c_space
        
        self.thisptr.colorSpace(c_space)

    def test(self):
        print self.thisptr.colorSpace()

    def __dealloc__(self):
        del self.thisptr

