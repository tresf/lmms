#!/bin/bash

# Recolor icon
echo Recoloring vector images...
case "$1" in
	"-r" ) # Release
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' icon.svg > recolored-icon.svg
	sed 's/#780116/#249a56/g' logo-small.svg > recolored-logo-small.svg
	sed 's/#780116/#249a56/g' logo.svg > recolored-logo.svg
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' splash.svg > recolored-splash.svg
	;;
	"-b" | "-rc" ) # Beta/Release Candidate
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' icon.svg > recolored-icon.svg
	sed 's/#780116/#0267c1/g' logo-small.svg > recolored-logo-small.svg
	sed 's/#780116/#0267c1/g' logo.svg > recolored-logo.svg
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' splash.svg > recolored-splash.svg
	;;
	"-c" | "-n" ) # Canary/Nightly
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' icon.svg > recolored-icon.svg
	sed 's/#780116/#ffa40f/g' logo-small.svg > recolored-logo-small.svg
	sed 's/#780116/#ffa40f/g' logo.svg > recolored-logo.svg
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' splash.svg > recolored-splash.svg
	;;
	* ) # No type specified, leave it be
	sed '' icon.svg > recolored-icon.svg
	sed '' logo-small.svg > recolored-logo-small.svg
	sed '' logo.svg > recolored-logo.svg
	sed '' splash.svg > recolored-splash.svg
	;;
esac

# Generate raster images
echo Generating raster images for icon...
rsvg-convert -w 128 -h 128 recolored-icon.svg -o icon_128x128.png
rsvg-convert -w 64 -h 64 recolored-icon.svg -o icon_64x64.png
rsvg-convert -w 48 -h 48 recolored-icon.svg -o icon_48x48.png
rsvg-convert -w 32 -h 32 recolored-icon.svg -o icon_32x32.png
rsvg-convert -w 16 -h 16 recolored-icon.svg -o icon_16x16.png

echo Generating raster image for splash screen...
rsvg-convert -w 680 -h 573 recolored-splash.svg -o "../../data/themes/default/splash.png"

echo Generating raster images for NSIS installer...
rsvg-convert -w 192 -h 192 recolored-logo-small.svg -o ../nsis/assets/SmallLogo.png
rsvg-convert -w 600 -h 600 recolored-logo.svg -o ../nsis/assets/Logo.png

# Generate Windows .ico icon
echo Generating Windows .ico from raster images...
convert icon_16x16.png icon_32x32.png icon_48x48.png icon_64x64.png icon_128x128.png -background transparent ../nsis/icon.ico

# Clean up images
echo Cleaning up temporary images...
rm -f recolored*.svg
rm -f icon_*.png
