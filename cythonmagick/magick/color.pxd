
from libcpp.string cimport string
cdef extern from "Magick++/Include.h" namespace "Magick":
    ctypedef unsigned short Quantum 
    
cdef extern from "Magick++/Color.h" namespace "Magick":
    cdef cppclass Color:
        Color()
        Color(string&) except +
        Color(Quantum, #red_
              Quantum, #green_
              Quantum, #blue_
              ) 
        Color(Quantum, #red_
              Quantum, #green_
              Quantum, #blue_
              Quantum, #alpha_
              ) 
        void redQuantum(Quantum)
        const Quantum redQuantum()
        void greenQuantum(Quantum)
        const Quantum greenQuantum()
        void blueQuantum (Quantum)
        const Quantum blueQuantum()
        void alphaQuantum(Quantum)
        const Quantum alphaQuantum()
        #void alpha(double)
        #double alpha()
        
    cdef cppclass ColorRGB(Color):
        ColorRGB( double, double, double)
        ColorRGB()
        ColorRGB( const Color& )
        void red(double)
        double red()
        void green(double)
        double green()
        void blue(double)
        double blue()
        void alpha(double)
        double alpha()