
from libcpp.string cimport string
from cython.operator cimport dereference as deref

from magick.color cimport Color as magickColor
from magick.color cimport ColorRGB as magickColorRGB


cdef class Color:
    cdef magickColor *thisptr
    
    def __cinit__(self,color=None):
        if color:
            self.thisptr = new magickColor(color)
        else:
            self.thisptr = new magickColor("black")
            
    def __dealloc__(self):
        if self.thisptr is not NULL:
        
            del self.thisptr
            
    def set_rgba(self, r=None,g=None,b=None,a=None):
        color = <magickColorRGB*> self.thisptr
        
        if r is not None:
            color.red(r)
        if g is not None:
            color.green(g)            
        if b is not None:
            color.blue(b)
        if a is not None:
            color.alpha(a)
            
        self.thisptr.redQuantum(color.redQuantum())
        self.thisptr.greenQuantum(color.greenQuantum())
        self.thisptr.blueQuantum(color.blueQuantum())
        self.thisptr.alphaQuantum(color.alphaQuantum())
        
    def get_rgba(self):
        color = <magickColorRGB*> self.thisptr
        
        return color.red(),color.green(),color.blue(),color.alpha()
    
    def tostring(self):
        
        s = <string> deref(self.thisptr)
        
        return s

    property red:
        def __get__(self):
            r,g,b,a = self.get_rgba()
            return r
        def __set__(self,value):
            self.set_rgba(r=value)
            
    property green:
        def __get__(self):
            r,g,b,a = self.get_rgba()
            return g
        def __set__(self,value):
            self.set_rgba(g=value)
            
    property blue:
        def __get__(self):
            r,g,b,a = self.get_rgba()
            return b
        def __set__(self,value):
            self.set_rgba(b=value)
            
    property alpha:
        def __get__(self):
            r,g,b,a = self.get_rgba()
            return a
        def __set__(self,value):
            self.set_rgba(a=value)
        