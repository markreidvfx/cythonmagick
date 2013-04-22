
cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef enum GravityType:
        ForgetGravity
        NorthWestGravity
        NorthGravity
        NorthEastGravity
        WestGravity
        CenterGravity
        EastGravity
        SouthWestGravity
        SouthGravity
        SouthEastGravity
        StaticGravity
