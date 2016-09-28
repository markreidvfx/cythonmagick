from libcpp.string cimport string
from libcpp cimport bool
from image cimport Image
from channel cimport ChannelType
cimport blob

cdef extern from "Magick++/STL.h" namespace "Magick" nogil:
    void writeImages[T](T first_, T last_, string &imageSpec, bool adjoin_) except +
    void readImages[T](T *sequence_, string imageSpec_) except +
    void combineImages[T](Image *combinedImage_, T first_, T last_, ChannelType channel_) except +
