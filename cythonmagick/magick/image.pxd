
from libcpp.string cimport string
from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType

cdef extern from "Magick++/Blob.h" namespace "Magick":
    cdef cppclass Blob:
        Blob() except +
        size_t length()

cdef extern from "Magick++/Image.h" namespace "Magick":
    void InitializeMagick(const char*)
    cdef cppclass Image:
        Image(string) except +
        void write(const string&)
        void resize(const Geometry&)
        void rotate(const double)
        void display()
        void colorSpace(ColorspaceType)
        ColorspaceType colorSpace()
        void quantizeColorSpace(ColorspaceType)
        void quantize()
        void compressType(CompressionType)
        CompressionType compressType()
        void magick(const string&)
        string magick()
