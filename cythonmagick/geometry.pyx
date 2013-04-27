
from libcpp.string cimport string
from cython.operator cimport dereference as deref

from magick.geometry cimport Geometry as magickGeometry

cdef class Geometry:
    cdef magickGeometry geo
    def __cinit__(self, width = 0, 
                        height = 0,
                        ssize_t xOff = 0,
                        ssize_t yOff = 0,
                        xNegative = False,
                        yNegative = False
                         ):
        
        
        self.geo = magickGeometry(width,height,xOff,yOff,xNegative,yNegative)
        
    def fromstring(self,string s):
        self.geo = <magickGeometry> s

    def tostring(self):      
        return <string> self.geo
    
    def __str__(self):
        return self.tostring()