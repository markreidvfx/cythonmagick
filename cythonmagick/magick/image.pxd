
from libcpp.string cimport string
from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType
from blob cimport Blob

cdef extern from "Magick++/Image.h" namespace "Magick":
    void InitializeMagick(const char*)
    cdef cppclass Image:
        Image(string) except +
        void write(const string&)
        void write(const Blob*)
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
