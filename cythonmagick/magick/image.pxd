
from libcpp.string cimport string
from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType
from gravity cimport GravityType
from filter cimport FilterTypes as FilterType
from blob cimport Blob
from color cimport Color

cdef extern from "Magick++/Image.h" namespace "Magick":
    void InitializeMagick(const char*)
    cdef cppclass Image:
        Image(string) except +
        Image(const Geometry&, Color&)
        Image(const Blob&)
        void read(const string)
        void read(const Blob&)
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
        void filterType(const FilterType)
        const FilterType filterType()
        void magick(const string&) except +
        string magick()
        void depth(const size_t)
        size_t depth()
        void size(const Geometry&)
        const Geometry size()
        void crop(const Geometry&)
        void extent(const Geometry&)
        void extent(const Geometry&, Color&)
        void extent(const Geometry&, const GravityType)
        void extent(const Geometry&, Color&, const GravityType)
        void backgroundColor(const const Color&)
        Color backgroundColor()
