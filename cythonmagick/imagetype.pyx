cimport imagetype

ImageTypes = dict(
undefined = imagetype.UndefinedType,
bilevel = imagetype.BilevelType,
grayscale = imagetype.GrayscaleType,
grayscalematte = imagetype.GrayscaleMatteType,
palette = imagetype.PaletteType,
palettematte = imagetype.PaletteMatteType,
truecolor = imagetype.TrueColorType,
truecolormatte = imagetype.TrueColorMatteType,
colorseparation = imagetype.ColorSeparationType,
colorseparationmatte = imagetype.ColorSeparationMatteType,
optimize = imagetype.OptimizeType,
palettebilevelmatte = imagetype.PaletteBilevelMatteType,
)

ClassTypes = dict(
undefined = imagetype.UndefinedClass,
direct = imagetype.DirectClass,
pseudo = imagetype.PseudoClass
)

MorphologyMethods = dict(
undefined         = imagetype.UndefinedMorphology,
convolve          = imagetype.ConvolveMorphology,
correlate         = imagetype.CorrelateMorphology,
erode             = imagetype.ErodeMorphology,
dilate            = imagetype.DilateMorphology,
erodeintensity    = imagetype.ErodeIntensityMorphology,
dilateintensity   = imagetype.DilateIntensityMorphology,
distance          = imagetype.DistanceMorphology,
open              = imagetype.OpenMorphology,
close             = imagetype.CloseMorphology,
openintensity     = imagetype.OpenIntensityMorphology,
closeintensity    = imagetype.CloseIntensityMorphology,
smooth            = imagetype.SmoothMorphology,
edgein            = imagetype.EdgeInMorphology,
edgeout           = imagetype.EdgeOutMorphology,
edge              = imagetype.EdgeMorphology,
tophat            = imagetype.TopHatMorphology,
bottomhat         = imagetype.BottomHatMorphology,
hitandmiss        = imagetype.HitAndMissMorphology,
thinning          = imagetype.ThinningMorphology,
thicken           = imagetype.ThickenMorphology,
voronoi           = imagetype.VoronoiMorphology,
iterativedistance = imagetype.IterativeDistanceMorphology,
)
