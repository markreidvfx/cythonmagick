
from PyQt4 import QtGui
from PyQt4 import QtCore
import sys
import os

import cythonmagick



class Image_Widget(QtGui.QWidget):

    def __init__(self,parent=None):
        super(Image_Widget,self).__init__(parent)
        
        
        magic_image = cythonmagick.Image("../tests/test_images/eyeball.jpg")
        magic_image.magick = "PNG" #Convert to a compatible imagetype
        image_string = magic_image.tostring()
        
        pixmap = QtGui.QPixmap()
        pixmap.loadFromData(image_string)
        
        self.label = QtGui.QLabel()
        self.label.setPixmap(pixmap)
        
        self.label.setScaledContents(True) #Scaleable for fun
        
        layout = QtGui.QVBoxLayout()
        layout.addWidget(self.label)
        self.setLayout(layout)




if __name__ == "__main__":

    app = QtGui.QApplication(sys.argv)
    
    main = Image_Widget()
    
    main.show()
    sys.exit(app.exec_())
