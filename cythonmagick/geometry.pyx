
from libcpp.string cimport string
from cython.operator cimport dereference as deref
from libcpp cimport bool

from geometry cimport Geometry as magickGeometry

cdef object toGeometry(magickGeometry geo):
    s = <string> geo
    return Geometry.fromstring(s)

cdef magickGeometry to_magickGeometry(object geo) except *:
    s = <string> str(geo)
    cdef magickGeometry g = magickGeometry(s)
    if not g.isValid():
        raise RuntimeError("invalid geometry")
    return  g

cdef class Geometry:
    cdef magickGeometry geo
    
    def __cinit__(self, width = 0, 
                        height = 0,
                        ssize_t xOff = 0,
                        ssize_t yOff = 0,
                        xNegative = False,
                        yNegative = False,
                        geometry_string = None
                         ):
        
        if geometry_string:
            self.geo = magickGeometry(str(geometry_string))
        else:
            self.geo = magickGeometry(width,height,xOff,yOff,xNegative,yNegative)
            
        if not self.geo.isValid():
            raise RuntimeError("invalid geometry")
            
    @classmethod
    def fromstring(cls,string s):
        return cls(geometry_string = s)
    
    def tostring(self):
        if not self.geo.isValid():
            raise RuntimeError("invalid geometry")      
        return <string> self.geo
    
    def __str__(self):
        return self.tostring()
    
    def __richcmp__(x,y,int op):
        if op not in (2,3):
            return False

        g1 = Geometry.fromstring(str(x))
        g2 = Geometry.fromstring(str(y))
        
        if op == 2:
            return g1.tostring() == g2.tostring()
        
        elif op == 3:
            return not g1.tostring() == g2.tostring()
    
    property width:
        def __get__(self):
            return self.geo.width()
        def __set__(self, size_t value):
            self.geo.width(value)
            
    property height:
        def __get__(self):
            return self.geo.height()
        def __set__(self, size_t value):
            self.geo.height(value)
            
    property xoffset:
    
        """X offset from origin"""
        
        def __get__(self):
            return self.geo.xOff()
        def __set__(self, ssize_t value):
            self.geo.xOff(value)
            
    property yoffset:
    
        """Y offset from origin"""
        
        def __get__(self):
            return self.geo.yOff()
        def __set__(self, ssize_t value):
            self.geo.yOff(value)
            
    property xnegative:
    
        """Sign of X offset negative? (X origin at right)"""
        
        def __get__(self):
            return self.geo.xNegative()
        def __set__(self, bool value):
            self.geo.xNegative(value)

    property ynegative:
    
        """Sign of Y offset negative? (Y origin at bottom)"""
        
        def __get__(self):
            return self.geo.yNegative()
        def __set__(self, bool value):
            self.geo.yNegative(value)
            
    property percent:
        
        """Width and height are expressed as percentages"""
        
        def __get__(self):
            return self.geo.percent()
        def __set__(self, bool value):
            self.geo.percent(value)
            
    property aspect:
        
        """Resize without preserving aspect ratio (!)"""
        
        def __get__(self):
            return self.geo.aspect()
        def __set__(self, bool value):
            self.geo.aspect(value)
        
    property greater:
    
        """Resize if image is greater than size (>)"""
        
        def __get__(self):
            return self.geo.greater()
        def __set__(self, bool value):
            self.geo.greater(value)
        
    property less:
        
        """Resize if image is less than size (<)"""
        
        def __get__(self):
            return self.geo.less()
        def __set__(self, bool value):
            self.geo.less(value)
            
    