
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
        Image(string) nogil except +
        Image(const Geometry&, Color&)
        Image(Blob&)
        void read(const string)
        void read(const Blob&)
        void write(const string&) nogil
        void write(Blob*) nogil
        void resize(const Geometry&) nogil
        void rotate(const double) nogil
        void display()
        void colorSpace(ColorspaceType) nogil
        ColorspaceType colorSpace() nogil
        void quantizeColorSpace(ColorspaceType)
        void quantize()
        void compressType(CompressionType)
        CompressionType compressType()
        void filterType(const FilterType)
        const FilterType filterType()
        void magick(const string&) nogil except +
        string magick() nogil
        void depth(const size_t)
        size_t depth()
        void size(const Geometry&)
        const Geometry size()
        void crop(const Geometry&)
        void extent(const Geometry&) nogil
        void extent(const Geometry&, Color&) nogil
        void extent(const Geometry&, const GravityType) nogil
        void extent(const Geometry&, Color&, const GravityType) nogil
        void backgroundColor(const const Color&)
        Color backgroundColor()
