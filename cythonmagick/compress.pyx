
cimport compress

CompressTypes = dict(
undefined = compress.UndefinedCompression,
bzip = compress.BZipCompression,
dxt1 = compress.DXT1Compression,
dxt3 = compress.DXT3Compression,
dxt5 = compress.DXT5Compression,
fax = compress.FaxCompression,
group4 = compress.Group4Compression,
jpeg = compress.JPEGCompression,
jpeg2000 = compress.JPEG2000Compression,   
losslessjpeg = compress.LosslessJPEGCompression,
lzw = compress.LZWCompression,
rle = compress.RLECompression,
zip = compress.ZipCompression,
zips = compress.ZipSCompression,
piz = compress.PizCompression,
pxr24 = compress.Pxr24Compression,
b44 = compress.B44Compression,
b44a = compress.B44ACompression,
lzma = compress.LZMACompression,           
jbig1 = compress.JBIG1Compression,           
jbig2 = compress.JBIG2Compression,
)

CompressTypes["none"] = compress.NoCompression
