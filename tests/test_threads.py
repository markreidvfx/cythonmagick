
import time
from concurrent.futures import ThreadPoolExecutor,ProcessPoolExecutor

import cythonmagick


def rotate(angle):
    
    i = cythonmagick.Image("logo:")
    #print angle
    i.rotate(angle)
    i.resize("1920x1080")
    s = i.tostring()
    return s

def thread_test(threads=1):
    
    with ProcessPoolExecutor(max_workers=threads) as e:
        for result in e.map(rotate,xrange(25)):
            length = len(result)
            pass
            #print result
        
        
    
    
    
if __name__ =="__main__":
    
    cythonmagick.initialize()
    start = time.time()
    thread_test(1)
    
    print '1:', time.time() - start, 'secs' 
    
    start = time.time()
    thread_test(8)
    
    print '8:', time.time() - start, 'secs' 