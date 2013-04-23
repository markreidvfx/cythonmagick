from coderinfo cimport CoderInfo
from libcpp.list cimport list as cpplist


cdef extern from "Magick++/STL.h" namespace "Magick":

    void coderInfoList(cpplist[CoderInfo]*, 
                        CoderInfo.MatchType,
                        CoderInfo.MatchType,
                        CoderInfo.MatchType,
                        )