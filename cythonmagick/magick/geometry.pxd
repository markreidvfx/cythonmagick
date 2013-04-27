
from libcpp.string cimport string
from libcpp cimport bool

cdef extern from "Magick++/Geometry.h" namespace "Magick":
    cdef cppclass Geometry:
        Geometry()
        Geometry(string&) except +
        Geometry(size_t,  #width_
                 size_t,  #height_
                 ssize_t, #xOff_ = 0
                 ssize_t, #yOff_ = 0
                 bool,    #xNegative_ = false Sign of X offset negative?
                 bool)    #yNegative_ = false Sign of Y offset negative?
        void width(size_t)
        size_t width()
        void height(size_t)
        size_t height()
        void xOff (ssize_t)
        ssize_t xOff()
        void yOff(ssize_t)
        ssize_t yOff()
        #Sign of X offset negative? (X origin at right)
        void xNegative(bool)
        bool xNegative()        
        #Sign of Y offset negative? (Y origin at bottom)
        void yNegative(bool)
        bool yNegative()
        #Width and height are expressed as percentages
        void percent(bool)
        bool percent()
        #Resize without preserving aspect ratio (!)
        void aspect(bool)
        bool aspect()       
        #Resize if image is greater than size (>)
        void greater(bool)
        bool greater()
        #Resize if image is less than size (<)
        void less(bool)
        bool less()
        #Does object contain valid geometry?
        void sValid(bool)
        bool isValid()
