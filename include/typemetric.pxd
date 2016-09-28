

cdef extern from "Magick++/TypeMetric.h" namespace "Magick" nogil:
    cdef cppclass TypeMetric:
        TypeMetric()
        double ascent()
        double descent()
        double maxHorizontalAdvance()
        double textHeight()
        double textWidth()
        double underlinePosition()
        double underlineThickness()
