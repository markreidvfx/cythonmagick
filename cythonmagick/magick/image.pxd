
from libcpp.string cimport string
from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType
from gravity cimport GravityType
from filter cimport FilterTypes as FilterType
from blob cimport Blob
from color cimport Color
from composite cimport CompositeOperator

cdef extern from "Magick++/Image.h" namespace "Magick":
    void InitializeMagick(const char*)
    cdef cppclass Image:
        Image(string) nogil except +
        Image(const Geometry&, Color&) nogil
        Image(Blob&) nogil
        
        #Image Image Manipulation Methods
        void composite(Image&,
                       ssize_t, #xOffset_
                       ssize_t, #yOffset_
                       CompositeOperator) nogil
        void composite(Image&, Geometry, CompositeOperator) nogil
        void composite(Image&, GravityType, CompositeOperator) nogil
        void crop(Geometry&) nogil except +
        void display()
        void extent(const Geometry&) nogil
        void extent(const Geometry&, Color&) nogil
        void extent(const Geometry&, const GravityType) nogil
        void extent(const Geometry&, Color&, const GravityType) nogil
        void read(const string)
        void read(Blob&)
        void resize(const Geometry&) nogil
        void rotate(const double) nogil
        void write(const string&) nogil
        void write(Blob*) nogil

        
        #Image Attributes
        void backgroundColor(const const Color&)
        Color backgroundColor()
        void colorSpace(ColorspaceType) nogil
        ColorspaceType colorSpace() nogil
        void compressType(CompressionType)
        CompressionType compressType()
        void depth(const size_t)
        size_t depth()
        void filterType(const FilterType)
        const FilterType filterType()
        void magick(const string&) nogil except +
        string magick() nogil
        void quantize()
        void quantizeColorSpace(ColorspaceType)
        void size(const Geometry&)
        const Geometry size()
