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
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension('cythonmagick',["cythonmagick/core.pyx"],
                                             language="c++",
                                             **extension_kwargs)]
)

