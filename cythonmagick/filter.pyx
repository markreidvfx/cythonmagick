cimport filter

FilterTypes = dict(
undefined = filter.UndefinedFilter,
point = filter.PointFilter,
box = filter.BoxFilter,
triangle = filter.TriangleFilter,
hermite = filter.HermiteFilter,
hanning = filter.HanningFilter,
hamming = filter.HammingFilter,
blackman = filter.BlackmanFilter,
gaussian = filter.GaussianFilter,
quadratic = filter.QuadraticFilter,
cubic = filter.CubicFilter,
catrom = filter.CatromFilter,
mitchell = filter.MitchellFilter,
jinc = filter.JincFilter,
sinc = filter.SincFilter,
sincfast = filter.SincFastFilter,
kaiser = filter.KaiserFilter,
welsh = filter.WelshFilter,
parzen = filter.ParzenFilter,
bohman = filter.BohmanFilter,
bartlett = filter.BartlettFilter,
lagrange = filter.LagrangeFilter,
lanczos = filter.LanczosFilter,
lanczossharp = filter.LanczosSharpFilter,
lanczos2 = filter.Lanczos2Filter,
lanczos2sharp = filter.Lanczos2SharpFilter,
robidoux = filter.RobidouxFilter,
)

DistortImageMethods = dict(
undefined = filter.UndefinedDistortion,
affine = filter.AffineDistortion,
affineprojection = filter.AffineProjectionDistortion,
scalerotatetranslate = filter.ScaleRotateTranslateDistortion,
perspective = filter.PerspectiveDistortion,
perspectiveprojection = filter.PerspectiveProjectionDistortion,
bilinearforward = filter.BilinearForwardDistortion,
bilinear = filter.BilinearDistortion,
bilinearreverse = filter.BilinearReverseDistortion,
polynomial = filter.PolynomialDistortion,
arc = filter.ArcDistortion,
polar = filter.PolarDistortion,
depolar = filter.DePolarDistortion,
cylinder2plane = filter.Cylinder2PlaneDistortion,
plane2cylinder = filter.Plane2CylinderDistortion,
barrel = filter.BarrelDistortion,
barrelinverse = filter.BarrelInverseDistortion,
shepards = filter.ShepardsDistortion,
resize = filter.ResizeDistortion,
sentinel = filter.SentinelDistortion,
)

IF MAGICKLIBVERSION > 686:
    FilterTypes['robidouxsharp'] = filter.RobidouxSharpFilter
    FilterTypes['cosine'] = filter.CosineFilter
    FilterTypes['spline'] = filter.SplineFilter
    FilterTypes['lanczosradius'] = filter.LanczosRadiusFilter
    #FilterTypes['sentinel'] = filter.SentinelFilter
