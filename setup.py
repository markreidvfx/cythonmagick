from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import shlex
import subprocess
import sys

def cmd_output(cmd):
    p = subprocess.Popen(cmd, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    stdout, stderr = p.communicate()
    if p.returncode < 0:
        print stdout
        print stderr
        sys.exit(p.returncode)
    
    return stdout, stderr

extension_kwargs = {}

cppflags,stderr = cmd_output(['Magick++-config', '--cppflags'])
libs,stderr = cmd_output(['Magick++-config', '--libs'])

version, stderr =  cmd_output(['Magick++-config', '--version'])

extension_kwargs['extra_compile_args'] = shlex.split(cppflags)
extension_kwargs['extra_link_args'] = shlex.split(libs)

version = version.strip()
MagickLibVersion  = int(version.split(' ')[0].replace('.', ''))
                                
compile_time_env = {'MAGICKLIBVERSIONSTRING':version, 'MAGICKLIBVERSION':MagickLibVersion}

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
    
    ext_modules = cythonize(extensions, 
                            include_path=['cythonmagick', 'include'], 
                            compile_time_env=compile_time_env),
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

