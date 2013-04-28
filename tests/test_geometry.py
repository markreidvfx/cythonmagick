
import unittest
import subprocess
from pprint import pprint
import cythonmagick

from common import *

class TestStringConvert(unittest.TestCase):
        
    def setUp(self):
        cythonmagick.initialize()
        
        
    def test_initalize(self):
        
        g = cythonmagick.Geometry()
        #print g.tostring()
        
        g = cythonmagick.Geometry(1920,1080)
        
        #print g.tostring()
        
        g = cythonmagick.Geometry(1920, 1080,10,10,True,True)

        with self.assertRaises(RuntimeError):
            g = cythonmagick.Geometry.fromstring("thsi si a badd size")
        
        
    def test_size(self):
        g = cythonmagick.Geometry()

        for x,y in ((120321,0120),(1212,2122),(32,23)):
            
            g.width = x
            g.height = y
            self.assertEqual(g.width, x)
            self.assertEqual(g.height, y)
        
    def test_offset(self):
        g = cythonmagick.Geometry()
        for x,y in ((120321,-0120),(1212,-2122),(32,-23)):
            
            
            g.xoffset = x
            g.yoffset = y
            
            self.assertEqual(g.xoffset, x)
            self.assertEqual(g.yoffset, y)
            
    def test_negative(self):
  
        g = cythonmagick.Geometry.fromstring("18x12-1-10")
        #print g
        #print g.xnegative
        self.assertTrue(g.xnegative)
        self.assertTrue(g.ynegative)
         
        g = cythonmagick.Geometry.fromstring("18x12+1+10")
        #print str(g)
        #print g.xnegative,g.ynegative
        self.assertFalse(g.xnegative)
        self.assertFalse(g.ynegative)
        
    def test_percent(self):
        g = cythonmagick.Geometry.fromstring("1920x1080%")
        self.assertTrue(g.percent)        
        g = cythonmagick.Geometry.fromstring("1920x1080")
        self.assertFalse(g.percent)
        g.percent = True
        self.assertTrue(g.percent)
        g.percent = False
        self.assertFalse(g.percent)
        
    def test_aspect(self):
        g = cythonmagick.Geometry.fromstring("1920x1080!")
        self.assertTrue(g.aspect)
        g = cythonmagick.Geometry.fromstring("1920x1080")
        self.assertFalse(g.aspect)
        g.aspect = True
        self.assertTrue(g.aspect)
        g.aspect = False
        self.assertFalse(g.aspect)
        
    def test_greater(self):
        g = cythonmagick.Geometry.fromstring("1920x1080+10-20>")
        self.assertTrue(g.greater)
        g = cythonmagick.Geometry.fromstring("1920x1080")
        self.assertFalse(g.greater)
        g.greater = True
        self.assertTrue(g.greater)
        g.greater = False
        self.assertFalse(g.greater)
    
    def test_less(self):
        g = cythonmagick.Geometry.fromstring("1920x1080+10-20<")
        self.assertTrue(g.less)
        g = cythonmagick.Geometry.fromstring("1920x1080")
        self.assertFalse(g.less)
        g.less = True
        self.assertTrue(g.less)
        g.less = False
        self.assertFalse(g.less)
        

if __name__ == '__main__':
    unittest.main()
