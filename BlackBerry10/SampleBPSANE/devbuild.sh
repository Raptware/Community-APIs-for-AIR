#!/bin/sh
AIR_SDK_PATH="/Developer/SDKs/air_3.0_sdk/bin"

unzip -o as/bin/bpsane.swc
rm catalog.xml
cp native/Device-Debug/libbpsane-arm.so ./nativearm.so
cp native/Simulator-Debug/libbpsane-x86.so ./nativex86.so
eval $AIR_SDK_PATH/adt -package -target ane bpsdemo.ane extension.xml -swc as/bin/bpsane.swc -platform QNX-ARM -C . library.swf nativearm.so -platform QNX-x86 -C . library.swf nativex86.so 
rm nativearm.so
rm nativex86.so
rm library.swf
cp bpsdemo.ane app/bpsdemo.ane