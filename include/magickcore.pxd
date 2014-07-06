

cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef struct Image:
        pass
    
    ctypedef enum MagickBooleanType:
        MagickFalse
        MagickTrue
        
    char *GetImageProperty(Image *image, const char *key)
    char *GetNextImageProperty(Image *image)
    void ResetImagePropertyIterator(Image *image)
    MagickBooleanType DeleteImageProperty(Image *image, char *property)
    
    char *GetNextImageArtifact(Image *image)
    void ResetImageArtifactIterator(Image *image)
    MagickBooleanType DeleteImageArtifact(Image *image, char *property)