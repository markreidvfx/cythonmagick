from libcpp.string cimport string


cdef extern from "Magick++/Blob.h" namespace "Magick":
    cdef cppclass Blob:
        Blob() except +
        void update(const void*, size_t)
        void updateNoCopy(void*, size_t)
        base64(const string)
        string base64()
        size_t length()
        const void* data()
        
