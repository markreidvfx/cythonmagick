
from libcpp.string cimport string
cdef extern from "Magick++/Include.h" namespace "Magick":
    ctypedef unsigned short Quantum 
    
cdef extern from "Magick++/Color.h" namespace "Magick" nogil:
    cdef cppclass Color:
        Color(string&) except +
        Color() except +
        Color(Quantum red,
              Quantum green,
              Quantum blue,
              ) except +
        Color(Quantum red,
              Quantum green,
              Quantum blue,
              Quantum alpha,
              ) except +
        void redQuantum(Quantum) except +
        const Quantum redQuantum() except +
        void greenQuantum(Quantum) except +
        const Quantum greenQuantum() except +
        void blueQuantum (Quantum) except +
        const Quantum blueQuantum() except +
        void alphaQuantum(Quantum) except +
        const Quantum alphaQuantum() except +
        #void alpha(double)
        #double alpha()
        
    cdef cppclass ColorRGB(Color):
        ColorRGB()
        ColorRGB(string&) except +
        ColorRGB( double, double, double) except+
        void red(double)
        double red()
        void green(double)
        double green()
        void blue(double)
        double blue()
        void alpha(double)
        double alpha()