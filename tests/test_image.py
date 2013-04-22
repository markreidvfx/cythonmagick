
import unittest
import subprocess

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
    def test_fromstring(self):
        
        test_image = get_test_image("eyeball.jpg")
        
        f = open(test_image)
        s = f.read()
        f.close()
        
        out1 = output_test_image("fromstring_test1.ppm")
        out2 = output_test_image("fromstring_test2.ppm")
        
        i = cythonmagick.Image()
        i.resize("1920x1090")
        i.fromstring(s)
        i.write(out1)
        
        cmd = ['convert',test_image,out2]
        subprocess.check_call(cmd)
        
        f = open(out1,'rb')
        s1 = f.read()
        f.close()
        
        f = open(out2,'rb')
        s2 = f.read()
        f.close()
        
        self.assertEqual(len(s1),len(s2))
        self.assertEqual(s1,s2)
        
        
        

if __name__ == '__main__':
    unittest.main()
