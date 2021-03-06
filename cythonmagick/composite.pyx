cimport composite

CompositeOperators = dict(
undefined = composite.UndefinedCompositeOp,
modulusadd = composite.ModulusAddCompositeOp,
atop = composite.AtopCompositeOp,
blend = composite.BlendCompositeOp,
bumpmap = composite.BumpmapCompositeOp,
changemask = composite.ChangeMaskCompositeOp,
clear = composite.ClearCompositeOp,
colorburn = composite.ColorBurnCompositeOp,
colordodge = composite.ColorDodgeCompositeOp,
colorize = composite.ColorizeCompositeOp,
copyblack = composite.CopyBlackCompositeOp,
copyblue = composite.CopyBlueCompositeOp,
copy = composite.CopyCompositeOp,
copycyan = composite.CopyCyanCompositeOp,
copygreen = composite.CopyGreenCompositeOp,
copymagenta = composite.CopyMagentaCompositeOp,
copyopacity = composite.CopyOpacityCompositeOp,
copyred = composite.CopyRedCompositeOp,
copyyellow = composite.CopyYellowCompositeOp,
darken = composite.DarkenCompositeOp,
dstatop = composite.DstAtopCompositeOp,
dst = composite.DstCompositeOp,
dstin = composite.DstInCompositeOp,
dstout = composite.DstOutCompositeOp,
dstover = composite.DstOverCompositeOp,
difference = composite.DifferenceCompositeOp,
displace = composite.DisplaceCompositeOp,
dissolve = composite.DissolveCompositeOp,
exclusion = composite.ExclusionCompositeOp,
hardlight = composite.HardLightCompositeOp,
hue = composite.HueCompositeOp,
lighten = composite.LightenCompositeOp,
linearlight = composite.LinearLightCompositeOp,
luminize = composite.LuminizeCompositeOp,
minusdst = composite.MinusDstCompositeOp,
modulate = composite.ModulateCompositeOp,
multiply = composite.MultiplyCompositeOp,
out = composite.OutCompositeOp,
over = composite.OverCompositeOp,
overlay = composite.OverlayCompositeOp,
plus = composite.PlusCompositeOp,
replace = composite.ReplaceCompositeOp,
saturate = composite.SaturateCompositeOp,
screen = composite.ScreenCompositeOp,
softlight = composite.SoftLightCompositeOp,
srcatop = composite.SrcAtopCompositeOp,
src = composite.SrcCompositeOp,
srcin = composite.SrcInCompositeOp,
srcout = composite.SrcOutCompositeOp,
srcover = composite.SrcOverCompositeOp,
modulussubtract = composite.ModulusSubtractCompositeOp,
threshold = composite.ThresholdCompositeOp,
xor = composite.XorCompositeOp,
dividedst = composite.DivideDstCompositeOp,
distort = composite.DistortCompositeOp,
blur = composite.BlurCompositeOp,
pegtoplight = composite.PegtopLightCompositeOp,
vividlight = composite.VividLightCompositeOp,
pinlight = composite.PinLightCompositeOp,
lineardodge = composite.LinearDodgeCompositeOp,
linearburn = composite.LinearBurnCompositeOp,
mathematics = composite.MathematicsCompositeOp,
dividesrc = composite.DivideSrcCompositeOp,
minussrc = composite.MinusSrcCompositeOp,
darkenintensity = composite.DarkenIntensityCompositeOp,
)

CompositeOperators["none"] = composite.NoCompositeOp
CompositeOperators['in'] = composite.InCompositeOp
