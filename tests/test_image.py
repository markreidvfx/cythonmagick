
import unittest
import subprocess
from pprint import pprint
import cythonmagick

from common import *

class TestStringConvert(unittest.TestCase):
    
    def setUp(self):
        cythonmagick.initialize()
        
    def test_formats(self):
        
        
        for item in cythonmagick.listformats(read=True):
            self.assertEqual(item['read'], True)
        for item in cythonmagick.listformats(read=False):
            self.assertEqual(item['read'], False)
        
        for item in cythonmagick.listformats(write=True):
            self.assertEqual(item['write'], True)
        for item in cythonmagick.listformats(write=False):
            self.assertEqual(item['write'], False)
            
        for item in cythonmagick.listformats(multiframe=True):
            self.assertEqual(item['multiframe'], True)
            
        for item in cythonmagick.listformats(multiframe=False):
            self.assertEqual(item['multiframe'], False)
            
        for item in cythonmagick.listformats(read=True,write=True):
            self.assertEqual(item['read'], True)
            self.assertEqual(item['write'], True)
            
        for item in cythonmagick.listformats(read=True,write=False):
            self.assertEqual(item['read'], True)
            self.assertEqual(item['write'], False)
            
        
        #for item in cythonmagick.listformats():
            #print item['name'],':',item['description']
            #print "   ", 'read:',item['read'], 'write:', item['write'],'multiframe:',item['multiframe']
            
    def test_filter(self):
        
        filters = dict(cythonmagick.FilterTypes)
        
        
        
        for f in filters.keys():
            i = cythonmagick.Image(get_test_image("eyeball.jpg"))
            
            i.filter = f
            
            i.resize("10x10")
            
            self.assertEqual(i.filter,f)
            
        
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
        
    def test_colorspace(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        #s = i.tostring()
        
        #print cythonmagick.ColorspaceTypes
        ColorspaceTypes = dict(cythonmagick.ColorspaceTypes)
        
        del ColorspaceTypes['transparent']
        
        for c in ColorspaceTypes.keys():
            
            #i.fromstring(s)
            i.colorspace = c
            #print i.colorspace,c
            self.assertEqual(i.colorspace,c)
            
        for c in ("YUV","yUv","yuv"):
            #i.fromstring(s)
            i.colorspace = c
            self.assertEqual(i.colorspace,"yuv")
        
        for c in ("Cow","Pig"):
            with self.assertRaises(KeyError):
                i.colorspace = c
                
    def test_compress(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        i.magick = "TIFF"
        
        
        for item in ("none", "LZW", 'ZIP', "RLE"):
            i.compress = item
            
            out = output_test_image("compress_test_%s.%s" % (item,"tif"))
            
            i.write(out)
            
            i2 = cythonmagick.Image(out)
            
            self.assertEqual( i.compress.lower(),item.lower())
        
        
        if cythonmagick.coderinfo("EXR")['read'] == True:
            print 'testing exr compression'
            i.magick = "EXR"
            
            for item in ("none", "ZIP", 'ZIPS','Piz','PXR24',"RLE"):
                i.compress = item
                
                out = output_test_image("compress_test_%s.%s" % (item,"exr"))
                
                i.write(out)
                
                i2 = cythonmagick.Image(out)
                
                print i.compress, item
                
                self.assertEqual( i.compress.lower(),item.lower())
        else:
            print "No EXR Support"
        
        
    def test_size(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        geo = i.size()
         
        width,height = geo.width,geo.height
        
        self.assertEqual(600,width)
        self.assertEqual(593,height)
        
        i.resize("1920x1080!")
        
        geo = i.size()
        width,height = geo.width,geo.height
        
        self.assertEqual(1920,width)
        self.assertEqual(1080,height)
        
        
        geo = cythonmagick.Geometry.fromstring("1280x720!")
        
        i.resize(geo)
        geo = i.size()
        width,height = geo.width,geo.height
        
        self.assertEqual(1280,width)
        self.assertEqual(720,height)
    
    def test_crop(self):
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        
        g = cythonmagick.Geometry(500,480)
        
        i.crop(g)
        #i.display()
        
        self.assertEqual(i.size(), g)
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))

        i.crop("90x60-10-10")
        self.assertEqual(i.size(),"90x60")
        
        
        with self.assertRaises(RuntimeError):
            i.crop("this is not a valid geo size")
            
        
    def test_extent(self):
        
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        i.background = "red"
        i.extent("1920x1080",'Center')
        
        self.assertEqual(i.size(), "1920x1080")
        #i.display()
        
        i = cythonmagick.Image(get_test_image("eyeball.jpg"))
        i.background = "blue"
        i.extent("20x40",'Center')
        
        
        self.assertEqual(i.size(), "20x40")
        
        for gravity in ("what the","bad name"):
            with self.assertRaises(KeyError):
                i = cythonmagick.Image(get_test_image("eyeball.jpg"))
                i.extent("1920x1080",gravity)
                
        with self.assertRaises(RuntimeError):
            i.extent("this is not a valid geo size")
        
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
    
    def test_backgroundcolor(self):
        test_image = get_test_image("eyeball.jpg")
        
        i = cythonmagick.Image(test_image)
        
        for item in ('#FFFF00000000','#00000000FFFF'):
            
            i.background = item
            
            self.assertEqual(item, i.background)
            
        c = cythonmagick.Color("Blue")
        
        i.background = c
        self.assertEqual(i.background,c)
        
        for item in ("what the","bad name", 3412):
            with self.assertRaises(RuntimeError):
                i.background = item
                
    def test_composite(self):
        test_image = get_test_image("eyeball.jpg")
        i1 = cythonmagick.Image("logo:")
        i2 = cythonmagick.Image(test_image)
        
        i1.composite(i2,compose="multiply")
        
        i1 = cythonmagick.Image("logo:")
        
        i1.composite(i2,offset="-200x0",compose="multiply")
        
        ops = dict(cythonmagick.CompositeOperators)
        
        #these operators don't seem to work with composite
        del ops['blur']
        del ops['displace']
        del ops['distort']
        
        for compose in ops.keys():
            i1 = cythonmagick.Image("logo:")
            i1.composite(i2,compose=compose)
            i1 = cythonmagick.Image("logo:")
            i1.composite(i2,compose=compose,offset="-200x0")
            i1 = cythonmagick.Image("logo:")
            i1.composite(i2,compose=compose,offset=cythonmagick.Geometry(200,0))
        
        with self.assertRaises(TypeError):
            i1.composite("not a image")
            
        with self.assertRaises(KeyError):
            i1.composite(i2,gravity="this is not gravity")
        with self.assertRaises(KeyError):
            i1.composite(i2,compose="this is not a composite operator")
            
        with self.assertRaises(RuntimeError):
            i1.composite(i2,offset="this is a bad offset")
            
    def test_compare(self):
        
        i1 = cythonmagick.Image("logo:")
        i2 = cythonmagick.Image("logo:")
        
        self.assertTrue(i1.compare(i2))
        
        i2.rotate(180)
        
        self.assertFalse(i1.compare(i2))
        test_image = get_test_image("eyeball.jpg")
        i3 = cythonmagick.Image(test_image)
        
        i3.colorspace = "yuv"
        
        self.assertFalse(i1.compare(i3))
        
    def test_haldclut(self):
        orignal = cythonmagick.Image("logo:")
        i1 = cythonmagick.Image("logo:")
        
        
        lut = cythonmagick.Image("hald:10")
        lut.gamma(.5)
        
        i1.haldclut(lut)
        
        self.assertFalse(orignal.compare(i1))
        
            
            
if __name__ == '__main__':
    unittest.main()
