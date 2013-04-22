
from libcpp.string cimport string

cdef extern from "Magick++/Geometry.h" namespace "Magick":
    cdef cppclass Geometry:
        Geometry()
        Geometry(string&) except +
        size_t width()
        size_t height()

