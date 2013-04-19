
from magick cimport compress

compressTypes = dict(
Undefined = compress.UndefinedCompression,
BZip = compress.BZipCompression,
DXT1 = compress.DXT1Compression,
DXT3 = compress.DXT3Compression,
DXT5 = compress.DXT5Compression,
Fax = compress.FaxCompression,
Group4 = compress.Group4Compression,
JPEG = compress.JPEGCompression,
JPEG2000 = compress.JPEG2000Compression,   
LosslessJPEG = compress.LosslessJPEGCompression,
LZW = compress.LZWCompression,
RLE = compress.RLECompression,
Zip = compress.ZipCompression,
ZipS = compress.ZipSCompression,
Piz = compress.PizCompression,
Pxr24 = compress.Pxr24Compression,
B44 = compress.B44Compression,
B44A = compress.B44ACompression,
LZMA = compress.LZMACompression,           
JBIG1 = compress.JBIG1Compression,           
JBIG2 = compress.JBIG2Compression,
)

compressTypes["None"] = compress.NoCompression
