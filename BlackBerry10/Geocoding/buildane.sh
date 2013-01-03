#!/bin/sh
AIR_SDK_PATH="/Developer/SDKs/air_3.4/bin"

unzip -o as3/bin/geocoding.swc
unzip -o as3/bin/default.swc -d default
rm catalog.xml
cp native/Device-Debug/libgeocoding.so ./nativearm.so
cp native/Simulator-Debug/lib.so ./nativex86.so
eval $AIR_SDK_PATH/adt -package -target ane geocoding.ane native/extension.xml -swc as3/bin/geocoding.swc -platform QNX-ARM -C . library.swf nativearm.so -platform QNX-x86 -C . library.swf nativex86.so -platform default -C ./default library.swf
rm nativearm.so
rm nativex86.so
rm library.swf
rm -R default
cp geocoding.ane app/geocoding.ane
