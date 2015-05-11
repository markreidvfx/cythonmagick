from libcpp.string cimport string
from libcpp cimport bool

cimport blob

cdef extern from "Magick++/STL.h" namespace "Magick":
    void writeImages[T](T first_, T last_, string &imageSpec, bool adjoin_) except +
   # void writeImages[T](T first_, T last_, blob.Blob *blob, bool adjoin_) except +