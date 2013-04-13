
from libcpp.string cimport string

cdef extern from "Magick++/Geometry.h" namespace "Magick":
    cdef cppclass Geometry:
        Geometry(string&) except +

