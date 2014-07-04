
LDFLAGS ?= ""
CFLAGS ?= "-O0"

.PHONY: default build_ext build clean clean-all info test docs

default: build

dev:
	CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) python setup.py build_ext --inplace --debug

build_ext:
	CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) python setup.py build_ext --debug

build: build_ext
	python setup.py build

install: build
	python setup.py install
	
test:
	cd tests;nosetests -v

docs: build_ext
	make -C docs html

clean:
	- rm -rf build
	- find cythonmagick -name '*.cpp' -delete
	- find ./ -name '*.so' -delete
	- find ./ -name '*.dylib' -delete
	- find ./ -name '*.pyd' -delete
	- find ./ -name '*.dll' -delete