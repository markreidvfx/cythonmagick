#!/bin/bash

if [[ $MAGICKVERSION == current ]]; then

	sudo apt-get update -qq
	sudo apt-get install libmagick++-dev --fix-missing

else

	sudo apt-get update -qq
	sudo apt-get build-dep imagemagick --fix-missing
	sudo apt-get 
	wget http://www.imagemagick.org/download/releases/ImageMagick-$MAGICKVERSION.tar.gz
	mkdir ImageMagick
	tar -xf ImageMagick-$MAGICKVERSION.tar.gz -C ImageMagick --strip-components=1
	cd ImageMagick
	./configure --enable-hdri --without-lcms2 --without-lcms 
	make
	sudo make install
	cd ..

fi

identify --version