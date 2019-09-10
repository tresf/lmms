#!/bin/bash

# Recolor icon
echo "Recoloring vector images..."
case "$1" in
	"-r" ) # Release
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' ../branding/icon.svg > recolored-icon.svg
	sed 's/#780116/#249a56/g' ../branding/logo-small.svg > recolored-logo-small.svg
	sed 's/#780116/#249a56/g' ../branding/logo.svg > recolored-logo.svg
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' ../branding/splash.svg > recolored-splash.svg
	;;
	"-b" | "-rc" ) # Beta/Release Candidate
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' ../branding/icon.svg > recolored-icon.svg
	sed 's/#780116/#0267c1/g' logo-small.svg > ../branding/recolored-logo-small.svg
	sed 's/#780116/#0267c1/g' logo.svg > ../branding/recolored-logo.svg
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' ../branding/splash.svg > recolored-splash.svg
	;;
	"-c" | "-n" ) # Canary/Nightly
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' ../branding/icon.svg > recolored-icon.svg
	sed 's/#780116/#ffa40f/g' ../branding/logo-small.svg > recolored-logo-small.svg
	sed 's/#780116/#ffa40f/g' ../branding/logo.svg > recolored-logo.svg
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' ../branding/splash.svg > recolored-splash.svg
	;;
	* ) # No type specified, leave it be
	sed '' ../branding/icon.svg > recolored-icon.svg
	sed '' ../branding/logo-small.svg > recolored-logo-small.svg
	sed '' ../branding/logo.svg > recolored-logo.svg
	sed '' ../branding/splash.svg > recolored-splash.svg
	;;
esac

# Generate raster images
echo "Generating raster images for icon..."
for RES in 16 32 48 64 128
do
	rsvg-convert -w $RES -h $RES recolored-icon.svg -o "icon_${RES}x${RES}.png"
done

echo "Generating raster image for splash screen..."
rsvg-convert -w 680 -h 573 recolored-splash.svg -o ../../data/themes/default/splash.png

echo "Generating raster images for NSIS installer..."
rsvg-convert -w 192 -h 192 recolored-logo-small.svg -o assets/SmallLogo.png
rsvg-convert -w 600 -h 600 recolored-logo.svg -o assets/Logo.png

# Generate Windows .ico icon
echo "Generating Windows .ico from raster images..."
convert icon_16x16.png icon_32x32.png icon_48x48.png icon_64x64.png icon_128x128.png -background transparent icon.ico

# Clean up images
echo "Cleaning up temporary images..."
rm -f recolored*.svg
rm -f icon_*.png
