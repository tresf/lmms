#!/bin/bash

# Recolor icon
echo Recoloring vector icon...
case "$1" in
	"-r" ) # Release
	sed 's/#780116/#249a56/g; s/#c51306/#50d99b/g' icon.svg > recolored.svg
	;;
	"-b" | "-rc" ) # Beta/Release Candidate
	sed 's/#780116/#0267c1/g; s/#c51306/#09a9d9/g' icon.svg > recolored.svg
	;;
	"-c" | "-n" ) # Canary/Nightly
	sed 's/#780116/#ffa40f/g; s/#c51306/#fad200/g' icon.svg > recolored.svg
	;;
	* ) # No type specified, leave it be
	sed '' icon.svg > recolored.svg
	;;
esac

# Generate raster images
echo Generating raster images for icon...
for RES in 16 24 32 48 64 96 128
do
	mkdir -p icons/${RES}x${RES}/apps
	rsvg-convert -w $RES -h $RES -o "icons/${RES}x${RES}/apps/lmms.png" recolored.svg
done

for RES in 16 24 32 48 64 96 128
do
	mkdir -p icons/${RES}x${RES}@2/apps
	rsvg-convert -w $((RES * 2)) -h $((RES * 2)) -o "icons/${RES}x${RES}@2/apps/lmms.png" recolored.svg
done

mkdir -p icons/scalable/apps
cp recolored.svg icons/scalable/apps/lmms.svg

echo Replacing old icons with new ones...
cp -r -f icons ../linux/

# Clean up images
echo Cleaning up temporary images...
rm -f recolored.svg
rm -rf icons
