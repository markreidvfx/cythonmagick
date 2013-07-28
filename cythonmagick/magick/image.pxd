
from libcpp.string cimport string
from libcpp cimport bool

from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType
from gravity cimport GravityType
from filter cimport FilterTypes as FilterType
from imagetype cimport ImageType
from blob cimport Blob
from color cimport Color
from composite cimport CompositeOperator

cdef extern from "Magick++/Image.h" namespace "Magick":
    void InitializeMagick(const char*)
    cdef cppclass Image:
        Image()
        Image(string) nogil except +
        Image(const Geometry&, Color&) nogil
        Image(Blob&) nogil
        
        #Image Image Manipulation Methods
        bool compare(Image&) nogil
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
        void flip() nogil
        void flop() nogil
        void gamma(double) nogil
        void gamma(double, double, double) nogil
        void haldClut(Image&) nogil
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
        void debug(bool)
        bool debug()
        void depth(const size_t)
        size_t depth()
        void filterType(const FilterType)
        const FilterType filterType()
        void magick(const string&) nogil except +
        string magick() nogil
        void quality(size_t)
        size_t quality()
        void quantize()
        void quantizeColorSpace(ColorspaceType)
        void size(const Geometry&)
        void type(ImageType) nogil
        ImageType type() nogil
        const Geometry size()
        void verbose(bool)
        bool verbose()
