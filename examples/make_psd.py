
import cythonmagick


def make_psd(source_files, dest):

    depth = 8

    i = cythonmagick.Image(source_files[0])
    i.magick = "psd"
    i.depth = depth
    i.background = "transparent"
    i.attributes['label'] = "BG_LAYER"
    i.compress = "RLE"
    i.type = "truecolormatte"

    # first image is the flatten image representation
    layers = [i, i]
    if len(source_files) > 1:
        for i, path in enumerate(source_files[1:]):
            layer = cythonmagick.Image(path)
            layer.depth = depth
            layer.type = "truecolormatte"
            layer.attributes['label'] = "layer_%04d" % (i + 1)
            layers.append(layer)

    cythonmagick.write_images(layers, dest)

def run_cli():
    from optparse import OptionParser
    usage = 'usage: %prog [options] SOURCE DEST'
    parser = OptionParser(usage = usage)
    parser.add_option('-o', '--output', dest = 'output', default = None, help = "out psd file")
    (options, args) = parser.parse_args()
    if not options.output:
        parser.error("no output specified")

    make_psd(args, options.output)


if __name__ == "__main__":
    run_cli()
