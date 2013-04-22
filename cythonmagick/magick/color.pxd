
from libcpp.string cimport string

cdef extern from "Magick++/Color.h" namespace "Magick":
    cdef cppclass Color:
        Color(string&) except +
