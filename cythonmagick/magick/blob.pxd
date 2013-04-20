from libcpp.string cimport string


cdef extern from "Magick++/Blob.h" namespace "Magick":
    cdef cppclass Blob:
        Blob() except +
        base64(const string)
        string base64()
        size_t length()
        const void* data()
        
