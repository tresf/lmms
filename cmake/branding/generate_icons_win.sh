#!/bin/bash

# Recolor icon
echo Recoloring vector images...
case "$1" in
	"-r" ) # Release
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' icon.svg > icon_recolored.svg
	sed 's/#780116/#249a56/g' logo-small.svg > logo_small_recolored.svg
	sed 's/#780116/#249a56/g' logo.svg > logo_recolored.svg
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' splash.svg > splash-recolored.svg
	;;
	"-b" | "-rc" ) # Beta/Release Candidate
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' icon.svg > icon_recolored.svg
	sed 's/#780116/#0267c1/g' logo-small.svg > logo_small_recolored.svg
	sed 's/#780116/#0267c1/g' logo.svg > logo_recolored.svg
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' splash.svg > splash-recolored.svg
	;;
	"-c" | "-n" ) # Canary/Nightly
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' icon.svg > icon_recolored.svg
	sed 's/#780116/#ffa40f/g' logo-small.svg > logo_small_recolored.svg
	sed 's/#780116/#ffa40f/g' logo.svg > logo_recolored.svg
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' splash.svg > splash-recolored.svg
	;;
	* ) # No type specified, leave it be
	sed '' icon.svg > recolored.svg
	sed '' logo-small.svg > logo_small_recolored.svg
	sed '' logo.svg > logo_recolored.svg
	sed '' splash.svg > splash-recolored.svg
	;;
esac

# Generate raster images
echo Generating raster images for icon...
rsvg-convert -w 128 -h 128 -o icon_128x128.png icon_recolored.svg
rsvg-convert -w 64 -h 64 -o icon_64x64.png icon_recolored.svg
rsvg-convert -w 48 -h 48 -o icon_48x48.png icon_recolored.svg
rsvg-convert -w 32 -h 32 -o icon_32x32.png icon_recolored.svg
rsvg-convert -w 16 -h 16 -o icon_16x16.png icon_recolored.svg

echo Generating raster image for splash screen...
rsvg-convert -w 680 -h 573 -o "../../data/themes/default/splash.png" splash-recolored.svg

echo Generating raster images for NSIS installer...
rsvg-convert -w 192 -h 192 -o ../nsis/assets/SmallLogo.png logo_small_recolored.svg
rsvg-convert -w 600 -h 600 -o ../nsis/assets/Logo.png logo_recolored.svg

# Generate Windows .ico icon
echo Generating Windows .ico from raster images...
convert icon_16x16.png icon_32x32.png icon_48x48.png icon_64x64.png icon_128x128.png -background transparent ../nsis/icon.ico

# Clean up images
echo Cleaning up temporary images...
rm -f *recolored.svg
rm -f icon_*.png
