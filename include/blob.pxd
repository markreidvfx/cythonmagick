from libcpp.string cimport string

cdef extern from * namespace "Magick::Blob":
    ctypedef enum Allocator:
        MallocAllocator
        NewAllocator


cdef extern from "Magick++/Blob.h" namespace "Magick" nogil:
    cdef cppclass Blob:
        Blob() except +
        Blob(const void* data_, size_t length_) except +
        void update(const void*, size_t) except +
        void updateNoCopy(void* data, size_t length) except +
        void updateNoCopy(void* data, size_t length, Allocator allocator) except +
        base64(const string) except +
        string base64() except +
        size_t length() except +
        const void* data() except +
        
