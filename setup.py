from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import shlex
import subprocess

extension_kwargs = {}
try:
    p = subprocess.Popen(['Magick++-config', '--cppflags'], stdout=subprocess.PIPE)
except:
    print "Unable to find Magick++-config"

else:
    cppflags,stderr = p.communicate()
    p = subprocess.Popen(['Magick++-config', '--libs'],stdout=subprocess.PIPE)
    libs,stderr = p.communicate()
    extension_kwargs['extra_compile_args'] = shlex.split(cppflags) + ['-I./cythonmagick/magick']
    extension_kwargs['extra_link_args'] = shlex.split(libs)

setup(
    name="cythonmagick",
    version="0.1.1",
    description="Python Bindings for ImageMagick Magick++ API written in Cython",
    url='https://github.com/markreidvfx/cythonmagick',
    
    author='Mark Reid',
    author_email='mindmark@gmail.com',
    license='Apache License (2.0)',
    
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension('cythonmagick',["cythonmagick/core.pyx"],
                                             language="c++",
                                             **extension_kwargs)],
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2',
        'Topic :: Multimedia :: Graphics',
        'Topic :: Software Development :: Libraries',
    ],
)

