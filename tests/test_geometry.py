
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
        print g.tostring()
        
        g = cythonmagick.Geometry(1920,1080)
        
        print g.tostring()
        
        g = cythonmagick.Geometry(1920, 1080,10,10,True,True)
        
        print g.tostring()
        
        
        g.fromstring("1920x1080!")
        
        print g.tostring(), str(g), g
        

if __name__ == '__main__':
    unittest.main()
