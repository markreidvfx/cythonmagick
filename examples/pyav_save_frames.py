"""
messy example of how to use PyAV to extract frames and pass them to cythonmagick
"""

import os
import sys
import pprint
import time
import concurrent.futures
from concurrent.futures import ThreadPoolExecutor,ProcessPoolExecutor

import av
import av.video.frame
import cythonmagick

def convert(frame, number, format='dpx'):
    i = cythonmagick.Image()

    i.from_rawbuffer(frame.planes[0], frame.width, frame.height, 'rgb',  'short')

    
    v = "02:20:30:01"
    i.artifacts['dpx:television.time.code'] = v
    i.artifacts['dpx:film.slate'] = "slate"
    i.artifacts['dpx:television.frame_rate'] = '23.97'
    

    i.magick = 'dpx'
    i.depth = 10
    
#     i.rotate(number)
#     i.resize("1920x1080!")

    #raw_buffer = i.torawbuffer(0,0,1920,1080, 'rgb', 'char')
    r_frame = av.video.frame.VideoFrame(1920, 1080, 'rgb48le')
    
    i.into_rawbuffer(r_frame.planes[0], 0,0,1920,1080, 'rgb', 'short')
    #frame_round_trip = av.video.frame.VideoFrame.from_buffer(raw_buffer, 1920, 1080, 'rgb24')
    r_frame.to_image().save("test2.%04d.jpg" % number)
    
    
    #print len(bytearray()
    #
    #i.depth= 8
    print number,i.depth, i.artifacts['dpx:television.time.code']

    out_file = "test.%04d.%s" % (number, format)
    i.write(out_file)


start = time.time()
cythonmagick.initialize()  

video = av.open(sys.argv[1])
stream = next(s for s in video.streams if s.type == b'video')
frame_count =0 
    

with ThreadPoolExecutor(8) as executor:
    
    futures = []
    for packet in video.demux(stream):
        for frame in packet.decode():
            
            frame_count += 1
            
            # reformat is not very thread happy
            new_frame = frame.reformat(1920, 1080, 'rgb48le')
            futures.append(executor.submit(convert, new_frame, frame_count, 'dpx'))

            #convert(new_frame, frame_count)
            
            while len(futures) > 8 * 4:
                f = futures.pop(0)
                f.result()
    
        if frame_count > 100:
            break
        
    for f in concurrent.futures.as_completed(futures):
        r = f.result()
        
print "completed in %i secs" % (time.time() - start)