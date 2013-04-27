from libcpp.string cimport string


cdef extern from "Magick++/Blob.h" namespace "Magick":
    cdef cppclass Blob:
        Blob() nogil except +
        void update(const void*, size_t) nogil
        void updateNoCopy(void*, size_t) nogil
        base64(const string) nogil
        string base64() nogil
        size_t length() nogil
        const void* data() nogil
        
