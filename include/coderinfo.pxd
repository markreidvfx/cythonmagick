from libcpp.string cimport string
from libcpp cimport bool

cdef extern from "Magick++/CoderInfo.h" namespace "Magick":
    cdef cppclass CoderInfo:
        CoderInfo()
        CoderInfo(string) except +
        string name()
        string description()
        bool isReadable()
        bool isWritable()
        bool isMultiFrame()
        
cdef extern from * namespace "Magick::CoderInfo":
    ctypedef enum MatchType:
        AnyMatch      # match any coder
        TrueMatch     # match coder if true
        FalseMatch    # match coder if false