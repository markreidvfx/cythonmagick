from libcpp.string cimport string
cimport magickcore

cdef extern from "Magick++/Drawable.h" namespace "Magick" nogil:
    cdef cppclass DrawableBase:
        pass

    cdef cppclass DrawableLine(DrawableBase):
        DrawableLine( double startX_, double startY_,
                      double endX_, double endY_ )

    cdef cppclass DrawableEllipse(DrawableBase):
        DrawableEllipse(double originX_, double originY_,
                        double radiusX_, double radiusY_,
                        double arcStart_, double arcEnd_) except +
    cdef cppclass DrawableRectangle(DrawableBase):
        DrawableRectangle( double upperLeftX_, double upperLeftY_,
                          double lowerRightX_, double lowerRightY_ ) except +

    cdef cppclass DrawableRoundRectangle(DrawableBase):
        DrawableRoundRectangle(double centerX_,     double centerY_,
                               double width_,       double hight_,
                               double cornerWidth_, double cornerHeight_ ) except +

    cdef cppclass DrawableStrokeWidth(DrawableBase):
        DrawableBase(double width)

    cdef cppclass DrawableStrokeOpacity(DrawableBase):
        DrawableBase(double opacity)

    cdef cppclass DrawableFillOpacity(DrawableBase):
        DrawableFillOpacity(double opacity_)

    cdef cppclass DrawablePointSize(DrawableBase):
        DrawablePointSize(double pointSize_)

    cdef cppclass DrawableTextInterlineSpacing(DrawableBase):
        DrawableTextInterlineSpacing(double spacing_)

    cdef cppclass DrawableTextInterwordSpacing(DrawableBase):
        DrawableTextInterwordSpacing(double spacing_)

    cdef cppclass DrawableTextKerning(DrawableBase):
        DrawableTextInterwordSpacing(double kerning_)

    cdef cppclass DrawableFont(DrawableBase):
        DrawableFont(string &font_)
        DrawableFont(string &family_, magickcore.StyleType style_, unsigned int weight_, magickcore.StretchType stretch_)

    cdef cppclass DrawableText(DrawableBase):
        DrawableText(double x_, double y_, string text_)
        DrawableText(double x_, const double y_, string &text_, string &encoding_)
