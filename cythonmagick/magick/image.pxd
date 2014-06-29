
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

cdef extern from "Magick++/Functions.h" namespace "Magick":
    cdef void InitializeMagick(const char*)

cdef extern from "Magick++/Image.h" namespace "Magick" nogil:
    cdef cppclass Image:
        Image() except +
        Image(string) except +
        Image(const Geometry&, Color&) except +
        Image(Blob&) except +
        
        #Image Image Manipulation Methods
        bool compare(Image&) except +
        void composite(Image&,
                       ssize_t, #xOffset_
                       ssize_t, #yOffset_
                       CompositeOperator) nogil
        void composite(Image&, Geometry, CompositeOperator) except +
        void composite(Image&, GravityType, CompositeOperator) except +
        void crop(Geometry&) except +
        void display()
        void extent(const Geometry&) except +
        void extent(const Geometry&, Color&) except +
        void extent(const Geometry&, const GravityType) except +
        void extent(const Geometry&, Color&, const GravityType) except +
        void flip() except +
        void flop() except +
        void gamma(double) except +
        void gamma(double, double, double) except +
        void haldClut(Image&) except +
        void read(const string) except +
        void read(Blob&) except +
        void resize(const Geometry&) except +
        void rotate(const double) except +
        void write(const string&) except +
        void write(Blob*) except +

        
        #Image Attributes
        void backgroundColor(const const Color&) except +
        Color backgroundColor() except +
        void colorSpace(ColorspaceType) except +
        ColorspaceType colorSpace() nogil
        void compressType(CompressionType)
        CompressionType compressType() except +
        void debug(bool) except +
        bool debug() except +
        void depth(const size_t) except +
        size_t depth() except +
        void filterType(const FilterType) except +
        const FilterType filterType() except +
        void magick(const string&) except +
        string magick()  except +
        void quality(size_t) except +
        size_t quality() except +
        void quantize() except +
        void quantizeColorSpace(ColorspaceType) except +
        void size(const Geometry&) except +
        void type(ImageType) except +
        ImageType type() except +
        const Geometry size() except +
        void verbose(bool) except +
        bool verbose() except +
