

cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef struct Image:
        pass
    
    char *GetNextImageProperty(Image *image)
    void ResetImagePropertyIterator(Image *image)