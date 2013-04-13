
cdef extern from "Magick++/Include.h" namespace "Magick":
    ctypedef enum ColorspaceType:
        CMYKColorspace
        GRAYColorspace
        HSLColorspace
        HWBColorspace
        LogColorspace
        OHTAColorspace
        Rec601LumaColorspace
        Rec709LumaColorspace
        RGBColorspace
        sRGBColorspace
        TransparentColorspace
        UndefinedColorspace
        XYZColorspace
        YCbCrColorspace
        YCCColorspace
        YIQColorspace
        YPbPrColorspace
        YUVColorspace
