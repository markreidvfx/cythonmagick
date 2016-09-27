

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
