
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

    ctypedef enum ClassType:
        UndefinedClass
        DirectClass
        PseudoClass

    ctypedef enum MorphologyMethod:
        UndefinedMorphology
        ConvolveMorphology
        CorrelateMorphology
        ErodeMorphology
        DilateMorphology
        ErodeIntensityMorphology
        DilateIntensityMorphology
        DistanceMorphology
        OpenMorphology
        CloseMorphology
        OpenIntensityMorphology
        CloseIntensityMorphology
        SmoothMorphology
        EdgeInMorphology
        EdgeOutMorphology
        EdgeMorphology
        TopHatMorphology
        BottomHatMorphology
        HitAndMissMorphology
        ThinningMorphology
        ThickenMorphology
        VoronoiMorphology
        IterativeDistanceMorphology
