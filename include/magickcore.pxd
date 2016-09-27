

cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef struct Image:
        pass

    ctypedef enum MagickBooleanType:
        MagickFalse
        MagickTrue

    ctypedef enum StyleType:
        UndefinedStyle
        NormalStyle
        ItalicStyle
        ObliqueStyle
        AnyStyle

    ctypedef enum StretchType:
        UndefinedStretch
        NormalStretch
        UltraCondensedStretch
        ExtraCondensedStretch
        CondensedStretch
        SemiCondensedStretch
        SemiExpandedStretch
        ExpandedStretch
        ExtraExpandedStretch
        UltraExpandedStretch
        AnyStretch

    char *GetImageProperty(Image *image, const char *key)
    char *GetNextImageProperty(Image *image)
    void ResetImagePropertyIterator(Image *image)
    MagickBooleanType DeleteImageProperty(Image *image, char *property)

    char *GetImageArtifact(Image *image, const char *key)
    MagickBooleanType SetImageArtifact(Image *image, const char *key, const char *value)
    char *GetNextImageArtifact(Image *image)
    void ResetImageArtifactIterator(Image *image)
    MagickBooleanType DeleteImageArtifact(Image *image, char *property)
