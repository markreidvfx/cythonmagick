
import unittest
import subprocess
from pprint import pprint
import cythonmagick

from common import *

class TestStringConvert(unittest.TestCase):
    
    def setUp(self):
        cythonmagick.initialize()
        
    def test_initalize(self):
        
    
        c = cythonmagick.Color()
        
        c = cythonmagick.Color("Red")
        
        c = cythonmagick.Color("#FF0000")
        
        c = cythonmagick.Color("rgba(1,1,1,1)")
        
        with self.assertRaises(RuntimeError):
            c  = cythonmagick.Color("this is not a color")
    
    def test_from_rgba(self):
        
        c = cythonmagick.Color.from_rgba(1,0,0)
        
        self.assertEqual(c, 'red')
        
        with self.assertRaises(TypeError):
            c = cythonmagick.Color.from_rgba("goat","cow","pig")
             
        
    def test_tostring(self):
        
        for color in ('red',"green",'blue'):
            c = cythonmagick.Color(color)
            
            
            self.assertEqual(c, color)
            self.assertNotEqual(c, "black")
            self.assertFalse(c > color)
            self.assertFalse(c < color)
    
    def test_setting_rgb_color(self):
        
        
        
        
        for r,g,b,a in ((1, 1, 1, 1), 
                        (.2, .1, .5, .8), 
                        (.3, .4, .5, .6),
                        (.03, .04, .05, .06),
                        (.003, .004, .005, .006)):
            c = cythonmagick.Color()
            c.red = r
            c.green = g
            c.blue = b
            c.alpha = a
            
            #print 'red:', c.red,r
            #print 'green:', c.green,g
            #print 'blue:', c.blue,b
            #print 'alpha', c.alpha,a
            
            self.assertAlmostEquals(c.red, r,2)
            self.assertAlmostEquals(c.green, g,2)
            self.assertAlmostEquals(c.blue, b,2)
            self.assertAlmostEquals(c.alpha, a,2)
if __name__ == '__main__':
    unittest.main()
