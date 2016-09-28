cimport typemetric


cdef class TypeMetric(object):
    cdef typemetric.TypeMetric metric

    def to_dict(self):
        return dict(
        ascent = self.ascent,
        descent = self.descent,
        maxHorizontalAdvance = self.maxHorizontalAdvance,
        textHeight = self.textHeight,
        textWidth = self.textWidth,
        underlinePosition = self.underlinePosition,
        underlineThickness = self.underlineThickness,
        )

    def __repr__(self):
        return str(self.to_dict())

    property ascent:
        def __get__(self): return self.metric.ascent()
    property descent:
        def __get__(self): return self.metric.descent()
    property maxHorizontalAdvance:
        def __get__(self): return self.metric.maxHorizontalAdvance()
    property textHeight:
        def __get__(self): return self.metric.textHeight()
    property textWidth:
        def __get__(self): return self.metric.textWidth()
    property underlinePosition:
        def __get__(self): return self.metric.underlinePosition()
    property underlineThickness:
        def __get__(self): return self.metric.underlineThickness()
