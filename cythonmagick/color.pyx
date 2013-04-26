
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
    cdef magickColor *thisptr
    
    def __cinit__(self,color=None):
        if color:
            self.thisptr = new magickColor(str(color))
        else:
            self.thisptr = new magickColor("black")
            
    def __dealloc__(self):
        if self.thisptr is not NULL:
        
            del self.thisptr
            
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
        