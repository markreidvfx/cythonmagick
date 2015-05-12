cdef extern from "Magick++/Include.h" namespace "MagickCore":
    ctypedef enum ChannelType:
        UndefinedChannel
        RedChannel
        GrayChannel
        CyanChannel
        GreenChannel
        MagentaChannel
        BlueChannel
        YellowChannel
        AlphaChannel
        OpacityChannel
        MatteChannel
        BlackChannel
        IndexChannel
        CompositeChannels
        AllChannels
        TrueAlphaChannel
        RGBChannels
        GrayChannels
        SyncChannels
        DefaultChannels