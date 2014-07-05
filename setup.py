from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import shlex
import subprocess
import sys

extension_kwargs = {}
try:
    p = subprocess.Popen(['Magick++-config', '--cppflags'], stdout=subprocess.PIPE)
except:
    print "Unable to find Magick++-config"

else:
    cppflags,stderr = p.communicate()
    p = subprocess.Popen(['Magick++-config', '--libs'],stdout=subprocess.PIPE)
    libs,stderr = p.communicate()
    if p.returncode < 0:
        sys.exit(p.returncode)
    extension_kwargs['extra_compile_args'] = shlex.split(cppflags)
    extension_kwargs['extra_link_args'] = shlex.split(libs)
    
extensions= [Extension('cythonmagick',
                       ["cythonmagick/cythonmagick.pyx"],
                        language="c++",
                        **extension_kwargs)]

setup(
    name="cythonmagick",
    version="0.1.1",
    description="Python Bindings for ImageMagick Magick++ API written in Cython",
    url='https://github.com/markreidvfx/cythonmagick',
    
    author='Mark Reid',
    author_email='mindmark@gmail.com',
    license='Apache License (2.0)',
    
    ext_modules = cythonize(extensions, include_path=['cythonmagick', 'include']),
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

