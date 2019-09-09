#!/bin/bash

# Recolor icon
echo Recoloring vector icon...
case "$1" in
	"-r" ) # Release
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' icon.svg > recolored.svg
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' splash.svg > splash-recolored.svg
	;;
	"-b" | "-rc" ) # Beta/Release Candidate
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' icon.svg > recolored.svg
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' splash.svg > splash-recolored.svg
	;;
	"-c" | "-n" ) # Canary/Nightly
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' icon.svg > recolored.svg
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' splash.svg > splash-recolored.svg
	;;
	* ) # No type specified, leave it be
	sed '' icon.svg > recolored.svg
	sed '' splash.svg > splash-recolored.svg
	;;
esac

# Generate raster images
echo Generating raster images for icon...
rsvg-convert -w 1024 -h 1024 icon_512x512@2x.png recolored.svg
rsvg-convert -w 512 -h 512 -o icon_512x512.png recolored.svg
rsvg-convert -w 256 -h 256 -o icon_256x256.png recolored.svg
rsvg-convert -w 128 -h 128 -o icon_128x128.png recolored.svg
rsvg-convert -w 64 -h 64 -o icon_64x64.png recolored.svg
rsvg-convert -w 32 -h 32 -o icon_32x32.png recolored.svg
rsvg-convert -w 16 -h 16 -o icon_16x16.png recolored.svg

# Move to .iconset
mkdir lmms.iconset
cp icon_512x512@2x.png icon_512x512.png icon_256x256.png icon_128x128.png icon_64x64.png icon_32x32.png icon_16x16.png lmms.iconset

# Make @2x duplicates
cp icon_32x32.png lmms.iconset/icon_16x16@2x.png
cp icon_64x64.png lmms.iconset/icon_32x32@2x.png
cp icon_256x256.png lmms.iconset/icon_128x128@2x.png
cp icon_512x512.png lmms.iconset/icon_256x256@2x.png

# Generate macOS .icns from .iconset
echo Generating macOS .icns from raster images...
iconutil -c icns -o icon.icns lmms.iconset

echo Generating raster image for splash screen...
rsvg-convert -w 680 -h 573 -o "../../data/themes/default/splash.png" splash-recolored.svg

# Clean up images
echo Cleaning up temporary images...
rm -f *recolored.svg
rm -f icon_*.png
rm -r lmms.iconset
