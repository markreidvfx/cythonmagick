
from libcpp.string cimport string
from libcpp cimport bool

from geometry cimport Geometry
from colorspace cimport ColorspaceType
from compress cimport CompressionType
from gravity cimport GravityType
from filter cimport FilterTypes as FilterType
from imagetype cimport ImageType
from blob cimport Blob
from channel cimport ChannelType
from color cimport Color
from composite cimport CompositeOperator
from imagetype cimport StorageType
from imagetype cimport ClassType
cimport magickcore

cdef extern from "Magick++/Include.h" namespace "MagickCore" nogil:
    cdef void InitializeMagick(const char*)
    ctypedef struct PixelPacket

cdef extern from "Magick++/Image.h" namespace "Magick" nogil:
    cdef cppclass Image:
        Image() except +
        Image(string) except +
        Image(const Geometry&, Color&) except +
        Image(Blob&) except +
        Image(Blob&, Geometry &size, size_t depth, string &magick) except +
        Image(size_t width, size_t height, string map, StorageType type, void *pixels) except +

        #Image Image Manipulation Methods
        bool compare(Image&) except +
        void composite(Image&,
                       ssize_t, #xOffset_
                       ssize_t, #yOffset_
                       CompositeOperator)
        Geometry boundingBox()  except +
        void annotate(const string, Geometry &boundingArea_, GravityType gravity_, double degrees) except +
        void channel(const ChannelType channel_) except +
        void composite(Image&, Geometry, CompositeOperator) except +
        void composite(Image&, GravityType, CompositeOperator) except +
        void crop(Geometry&) except +
        void display()
        void erase()
        void extent(const Geometry&) except +
        void extent(const Geometry&, Color&) except +
        void extent(const Geometry&, const GravityType) except +
        void extent(const Geometry&, Color&, const GravityType) except +
        void flip() except +
        void flop() except +
        void fx(string expression, ChannelType channel) except +
        void gamma(double) except +
        void gamma(double, double, double) except +
        void haldClut(Image&) except +
        void negate(bool grayscale) except +
        void read(const string) except +
        void read(Blob&) except +
        void read(Blob&, Geometry &size, size_t depth, string &magick)
        void read(size_t width, size_t height, string map, StorageType type, void *pixels) except +
        void resize(const Geometry&) except +
        void rotate(const double) except +
        void strip() except +
        void clamp() except +
        void write(const string&) except +
        void write(Blob*) except +
        void write(size_t x, size_t y, size_t width, size_t height, string &map, StorageType type, void *pixels) except +


        #Image Attributes
        void adjoin(bool flag_) except +
        bool adjoin() except +
        void attribute(const string, const string) except +
        string attribute(const string) except +
        void artifact(const string, const string) except +
        string artifact(const string) except +
        void defineSet(const string& magick,  const string &key, bool flag) except +
        bool defineSet(const string& magick,  const string &key) except +
        void defineValue(const string &magick,const string &key, const string &value) except +
        string defineValue(const string &magick,const string &key) except +
        void backgroundColor(const const Color&) except +
        Color backgroundColor() except +
        void borderColor(const const Color&) except +
        Color borderColor() except +
        void boxColor(const const Color&) except +
        Color boxColor() except +
        void fillColor(const const Color&) except +
        Color fillColor() except +
        ClassType classType() except +
        void classType(ClassType class_) except +
        void colorFuzz(double fuzz_) except +
        double colorFuzz() except +
        void colorSpace(ColorspaceType) except +
        ColorspaceType colorSpace() except +
        void compressType(CompressionType) except +
        CompressionType compressType() except +
        void debug(bool) except +
        bool debug() except +
        void depth(const size_t) except +
        size_t depth() except +
        void filterType(const FilterType) except +
        const FilterType filterType() except +
        void fontPointsize(size_t pointSize_ ) except +
        size_t fontPointsize() except +
        bool matte() except +
        void matte(bool mattFlag_) except +
        void magick(const string&) except +
        string magick()  except +
        void page(Geometry &pageSize_) except +
        Geometry page()  except +
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

        magickcore.Image* image() except +
        const magickcore.Image* constImage() except +
        void modifyImage() except +

        # Pixels

        const PixelPacket* getConstPixels(ssize_t x_, ssize_t y_, size_t columns_, size_t rows_) except +
