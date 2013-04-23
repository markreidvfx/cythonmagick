
import unittest
import subprocess
from pprint import pprint
import cythonmagick

from common import *

class TestStringConvert(unittest.TestCase):
    
    def setUp(self):
        cythonmagick.initialize()
        
    def test_formats(self):
        
        for item in cythonmagick.listformats():
            print item['name'],':',item['description']
            print "   ", 'read:',item['read'], 'write:', item['write'],'multiframe:',item['multiframe']
        
    def test_coderinfo(self):
        
        d = cythonmagick.coderinfo("JPG")
        self.assertEqual(d['read'], True)
        self.assertEqual(d['write'], True)
        d = cythonmagick.coderinfo("BOB")
        self.assertEqual(d['read'], False)
        self.assertEqual(d['write'], False)
        
        #print cythonmagick.coderinfo("EXR")
        
    def test_value_lookup(self):
        
        d = {"One":1,"Two":2,"Three":3}
        
        self.assertEqual(cythonmagick._value_lookup(d,3),"Three")
        self.assertEqual(cythonmagick._value_lookup(d,1),"One")
        self.assertEqual(cythonmagick._value_lookup(d,5),None)
        
    
    def test_nocase_lookup(self):
        
        d = {"One":1,"Two":2,"Three":3}
        
        self.assertEqual(cythonmagick._nocase_lookup(d,"tHrEe"),3)
        self.assertEqual(cythonmagick._nocase_lookup(d,"THreE"),3)
        self.assertEqual(cythonmagick._nocase_lookup(d,"TwO"),2)
        self.assertEqual(cythonmagick._nocase_lookup(d,"One"),1)
        self.assertEqual(cythonmagick._nocase_lookup(d,"wee"),None)
        
    def test_colorspace(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        #s = i.tostring()
        
        #print cythonmagick.ColorspaceTypes
        ColorspaceTypes = dict(cythonmagick.ColorspaceTypes)
        
        del ColorspaceTypes['Transparent']
        
        for c in ColorspaceTypes.keys():
            
            #i.fromstring(s)
            i.colorspace = c
            #print i.colorspace,c
            self.assertEqual(i.colorspace,c)
            
        for c in ("YUV","yUv","yuv"):
            #i.fromstring(s)
            i.colorspace = c
            self.assertEqual(i.colorspace,"YUV")
        
        for c in ("Cow","Pig"):
            with self.assertRaises(ValueError):
                i.colorspace = c
                
        
        
    def test_size(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        width,height = i.size()
        
        self.assertEqual(600,width)
        self.assertEqual(593,height)
        
        i.resize("1920x1080!")
        
        
        width,height = i.size()
        
        self.assertEqual(1920,width)
        self.assertEqual(1080,height)
        
    def test_crop(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        #i.crop()
        
        
    def test_extent(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        i.extent("1920x1080","Red",'Center')
        
        #i.display()
        
    def test_depth(self):
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        out = output_test_image("depth_test.%s" % "miff")
        
        for d in (8,16):
            i.depth = d
            
            i.write(out)
            
            test_image = cythonmagick.Image(out)
            
            self.assertEqual(d, test_image.depth)
    
    def test_tostring_size_match(self):
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        for format in ("png","jpg","dpx","gif"):
            i.magick = format
            
            out = output_test_image("tostring_test.%s" % format)
            i.write(out)
            s = i.tostring()
            f = open(out)
            
            s2 = f.read()
            f.close()
            
            self.assertEqual(s, s2,"output image data does not match")
            
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
        self.assertEqual(s1,s2,msg="output image data does not match")
        
        
        

if __name__ == '__main__':
    unittest.main()
