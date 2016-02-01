#!/bin/sh
# expects acompc to be in your path variable e.g. PATH=$PATH:<air-sdk-compiler-home>/bin

acompc -source-path src -include-classes com.mediabrix.air.IAdEventsListener com.mediabrix.air.IMediabrixAPI com.mediabrix.air.MediabrixAirAPI -debug=false -output bin/MediabrixAir.swc -swf-version=14

unzip -o bin/MediabrixAir.swc
cp library.swf build/android
cp library.swf build/default
cp library.swf build/ios

adt -package -target ane build/mediabrix.ane extension.xml -swc bin/MediabrixAir.swc -platform Android-ARM -C build/android .  -platform iPhone-ARM -platformoptions iosplatformoptions.xml -C build/ios . -platform default -C build/default .

