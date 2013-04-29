
import time

from multiprocessing.dummy import Pool #Pool.imap handles memory better then ThreadPoolExecutor.map

import cythonmagick
import subprocess
import os


def rotate(angle):
    
    i = cythonmagick.Image("logo:")
    
    i.filter = "triangle"
    i.rotate(angle)
    i.extent("1920x1080")
    i.resize("1280x720")
    #out = os.path.expanduser('~/out/out.%04d.ppm') % angle
    #print out
    #i.write(out)
    i.magick = 'ppm'
    s = i.tostring()
    return s

def ffmpeg_encode(threads=1):
    
    
    cmd = ['ffmpeg', '-y', '-vcodec', 'ppm','-r','23.97', '-f', 'image2pipe','-i', '-']
    
    cmd.extend(['-vcodec', 'libx264','-pix_fmt','yuv420p', '-profile', 'baseline','-vb','15M','-crf', '16'])
    
    cmd.extend([os.path.expanduser('~/out.mov')])
    
    print subprocess.list2cmdline(cmd)
    
    p = None
    
    pool = Pool(threads)
    
    #with ThreadPoolExecutor(max_workers=threads) as e:
    for result in pool.imap(rotate,xrange(360)): 
        if p is None:
            p = subprocess.Popen(cmd,stdin=subprocess.PIPE)

        p.stdin.write(result)
        p.stdin.flush()
            
    p.stdin.close()
    
    p.wait()
    pool.close()
    pool.join()

    #
if __name__ =="__main__":
    
    cythonmagick.initialize()
    start = time.time()
    ffmpeg_encode(8)
    
    print 'encoded in', time.time() - start, 'secs' 