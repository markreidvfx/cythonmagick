from libcpp.string cimport string
from libcpp.list cimport list as cpplist
from cython.operator cimport dereference as deref, preincrement as inc

from coderlist cimport coderInfoList as magickCoderInfoList 
from coderinfo cimport CoderInfo as magickCoderInfo

cimport coderinfo

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
        read = coderinfo.AnyMatch
    elif read:
        read = coderinfo.TrueMatch
    else:
        read = coderinfo.FalseMatch
    
    if write is None:
        write = coderinfo.AnyMatch
    elif write:
        write = coderinfo.TrueMatch
    else:
        write = coderinfo.FalseMatch
        
    if multiframe is None:
        multiframe = coderinfo.AnyMatch
    elif multiframe:
        multiframe = coderinfo.TrueMatch
    else:
        multiframe = coderinfo.FalseMatch
        
    formats = []
    
    cdef cpplist[magickCoderInfo] coderlist = cpplist[magickCoderInfo]()
    magickCoderInfoList(&coderlist, read, write, multiframe)
    
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
        
    
    return formats