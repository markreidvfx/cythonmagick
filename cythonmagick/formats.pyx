from libcpp.string cimport string
from cython.operator cimport dereference as deref, preincrement as inc

from magick.coderlist cimport coderInfoList
from magick.coderinfo cimport CoderInfo as magickCoderInfo
from libcpp.list cimport list as cpplist

cimport magick.coderinfo

def coderinfo(string format):
    d = {}
    cdef magickCoderInfo *info
    try:
        info = new magickCoderInfo(format)
    except:
        d = {'name':format,'read':False, 'write':False,'multiframe':False}
        return d
    
    
    d['name'] = info.name()
    d['description'] = info.description()
    d['read'] = info.isReadable()
    d['write'] = info.isWritable()
    d['multiframe'] = info.isMultiFrame()
    
    return d

def listformats(read=None, write=None, multiframe=None):
    
    if read is None:
        read = magick.coderinfo.AnyMatch
    elif read:
        read = magick.coderinfo.TrueMatch
    else:
        read = magick.coderinfo.FalseMatch
    
    if write is None:
        write = magick.coderinfo.AnyMatch
    elif write:
        write = magick.coderinfo.TrueMatch
    else:
        write = magick.coderinfo.FalseMatch
        
    if multiframe is None:
        multiframe = magick.coderinfo.AnyMatch
    elif multiframe:
        multiframe = magick.coderinfo.TrueMatch
    else:
        multiframe = magick.coderinfo.FalseMatch
        
    formats = []
    
    cdef cpplist[magickCoderInfo] *coderlist = new cpplist[magickCoderInfo]()
    coderInfoList(coderlist,
                 read,
                 write,
                 magick.coderinfo.AnyMatch)
    
    cdef cpplist[magickCoderInfo].iterator it = coderlist.begin()
    
    while it != coderlist.end():
        info = deref(it)
        
        d = {}
        
        d['name'] = info.name()
        d['description'] = info.description()
        d['read'] = info.isReadable()
        d['write'] = info.isWritable()
        d['multiframe'] = info.isMultiFrame()
        
        formats.append(d)
        
        inc(it)
        
    del coderlist
    
    return formats