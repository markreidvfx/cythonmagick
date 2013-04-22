from magick cimport colorspace

ColorspaceTypes = dict(
CMYK = colorspace.CMYKColorspace,
GRAY = colorspace.GRAYColorspace,
HSL = colorspace.HSLColorspace,
HWB = colorspace.HWBColorspace,
Log = colorspace.LogColorspace,
OHTA = colorspace.OHTAColorspace,
Rec601Luma = colorspace.Rec601LumaColorspace,
Rec709Luma = colorspace.Rec709LumaColorspace,
RGB = colorspace.RGBColorspace,
sRGB = colorspace.sRGBColorspace,
Transparent = colorspace.TransparentColorspace,
Undefined = colorspace.UndefinedColorspace,
XYZ = colorspace.XYZColorspace,
YCbCr = colorspace.YCbCrColorspace,
YCC = colorspace.YCCColorspace,
YIQ = colorspace.YIQColorspace,
YPbPr = colorspace.YPbPrColorspace,
YUV = colorspace.YUVColorspace,
)
