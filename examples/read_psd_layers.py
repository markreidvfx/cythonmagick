import cythonmagick

def read_psd_layers(path):
    layers = cythonmagick.read_images(path)

    for image in layers[1:]:
        print image.attributes['label'], image.size(), image.type

def run_cli():
    from optparse import OptionParser
    usage = 'usage: %prog [options] SOURCE DEST'
    parser = OptionParser(usage = usage)
    (options, args) = parser.parse_args()

    read_psd_layers(args[0])

if __name__ == "__main__":
    run_cli()
