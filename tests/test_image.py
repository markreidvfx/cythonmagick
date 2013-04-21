
import unittest

import cythonmagick

from common import *

class TestStringConvert(unittest.TestCase):
    
    def setUp(self):
        cythonmagick.initialize()
        
    
    
    def test_tostring_size_match(self):
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        for format in ("png","exr","jpg","dpx","gif"):
            i.magick = format
            
            out = output_test_image("tostring_test.%s" % format)
            i.write(out)
            
            s = i.tostring()
            
            f = open(out)
            
            s2 = f.read()
            f.close()
            
            self.assertEqual(s, s2)
        
        
        

if __name__ == '__main__':
    unittest.main()
