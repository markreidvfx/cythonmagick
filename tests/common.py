
import os


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
    
