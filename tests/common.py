
import os
import unittest
import nose.tools

def get_test_image(name):
    
    dirname = os.path.dirname(__file__)
    
    return os.path.join(dirname, 'test_images',name)
    

def output_test_image(name):
    
    out_dir = os.path.join(os.path.dirname(__file__),'test_output')
    
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)
        
    out_file = os.path.join(out_dir, name)
    
    if os.path.exists(out_file):
        os.remove(out_file)
        
    return out_file

class AssertRaisesContext(object):
    def __init__(self, expected):
        self.expected = expected

    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, tb):
        self.exception = exc_val
        nose.tools.assert_equal(exc_type, self.expected)
        # if you get to this line, the last assertion must have passed
        # suppress the propagation of this exception
        return True

class TestCase(unittest.TestCase):
    
    def assertRaises(self, exc_type):
        return AssertRaisesContext(exc_type) 
    
