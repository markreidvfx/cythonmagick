cimport drawable


cdef class Drawable(object):
    cdef drawable.DrawableBase *ptr
    def __cinit__(self):
        self.ptr = NULL

    def __dealloc__(self):
        del self.ptr

cdef class Line(Drawable):

    def __init__(self, double start_x, double start_y,
                       double end_x,   double end_y):

        self.ptr = new drawable.DrawableLine(start_x, start_y,
                                             end_x,   end_y)

cdef class Ellipse(Drawable):

    def __init__(self, double origin_x, double origin_y,
                       double radius_x, double radius_y,
                       double arc_start, double arc_end):
        self.ptr = new drawable.DrawableEllipse(origin_x, origin_y,
                                            radius_x, radius_y,
                                            arc_start, arc_end)

cdef class Rectangle(Drawable):

    def __init__(self, double upper_left_x,  double upper_left_y,
                       double lower_right_x, double lowerright_y):
        self.ptr = new drawable.DrawableRectangle(upper_left_x,  upper_left_y,
                                                  lower_right_x, lowerright_y)

cdef class RoundRectangle(Drawable):

    def __init__(self, double center_x,     double centery,
                       double width,        double hight,
                       double corner_width, double corner_height):
        self.ptr = new drawable.DrawableRoundRectangle(center_x,     centery,
                                                       width,        hight,
                                                       corner_width, corner_height)
cdef class StrokeWidth(Drawable):

    def __init__(self, double width):
        self.ptr = new drawable.DrawableStrokeWidth(width)

cdef class StrokeOpacity(Drawable):
    def __init__(self, double opacity):
        self.ptr = new drawable.DrawableStrokeOpacity(opacity)
