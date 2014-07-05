
cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef enum ImageType:
        UndefinedType
        BilevelType
        GrayscaleType
        GrayscaleMatteType
        PaletteType
        PaletteMatteType
        TrueColorType
        TrueColorMatteType
        ColorSeparationType
        ColorSeparationMatteType
        OptimizeType
        PaletteBilevelMatteType
        
    ctypedef enum StorageType:
        CharPixel
        ShortPixel
        IntegerPixel
        FloatPixel
        DoublePixel