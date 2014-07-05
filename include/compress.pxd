cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef enum CompressionType:  
        UndefinedCompression
        NoCompression
        BZipCompression
        DXT1Compression
        DXT3Compression
        DXT5Compression
        FaxCompression
        Group4Compression
        JPEGCompression
        JPEG2000Compression      # ISO/IEC std 15444-1
        LosslessJPEGCompression
        LZWCompression
        RLECompression
        ZipCompression
        ZipSCompression
        PizCompression
        Pxr24Compression
        B44Compression
        B44ACompression
        LZMACompression            # Lempel-Ziv-Markov chain algorithm
        JBIG1Compression           # ISO/IEC std 11544 / ITU-T rec T.82
        JBIG2Compression
