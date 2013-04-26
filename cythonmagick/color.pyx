
from libcpp.string cimport string
from cython.operator cimport dereference as deref

from magick.color cimport Color as magickColor
from magick.color cimport ColorRGB as magickColorRGB


cdef object toColor(magickColor color):
    s = <string> color
    return Color(s)

cdef magickColor tomagickColor(object color) except *:
    s = <string> str(color)
    return  magickColor(s) 

cdef class Color:
    cdef double _r
    cdef double _g
    cdef double _b
    cdef double _a
    
    def __cinit__(self,color=None):
        self._r = 0
        self._g = 0
        self._b = 0
        self._a = 0
        cdef magickColorRGB c
        if color:
            c = magickColorRGB(str(color))
            self._r = c.red()
            self._g = c.green()
            self._b = c.blue()
            self._a = c.alpha()
            
    @classmethod       
    def from_rgba(cls,red=None, green=None, blue=None, alpha=None):
        c = cls()
        c.set_rgba(red,green,blue,alpha)
        return c
    
    @classmethod
    def fromstring(cls,string color):
        return cls(color)

    def __str__(self):
        return self.tostring()
    
    def __richcmp__(x,y,int op):
        if op not in (2,3):
            return False
        
        c1 = Color(x)
        c2 = Color(y)
        
        if op == 2:
            return c1.tostring() == c2.tostring()
        
        elif op == 3:
            return not c1.tostring() == c2.tostring()

    def set_rgba(self, r=None,g=None,b=None,a=None):
        if r is not None:
            self._r = r
        if g is not None:
            self._g = g         
        if b is not None:
            self._b = b
        if a is not None:
            self._a = a

    def get_rgba(self):
        return self._r,self._g,self._b,self._a
    
    def tostring(self):
        cdef magickColorRGB c = magickColorRGB(self._r,self._g,self._b)
        c.alpha(self._a)
        return <string> c

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
        