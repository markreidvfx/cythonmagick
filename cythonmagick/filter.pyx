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

IF MAGICKLIBVERSION > 686:
    FilterTypes['robidouxsharp'] = filter.RobidouxSharpFilter
    FilterTypes['cosine'] = filter.CosineFilter
    FilterTypes['spline'] = filter.SplineFilter
    FilterTypes['lanczosradius'] = filter.LanczosRadiusFilter
    #FilterTypes['sentinel'] = filter.SentinelFilter