#!/bin/sh
AIR_SDK_PATH="/Developer/SDKs/air_3.4/bin"

unzip -o as3/bin/bbmane.swc
unzip -o as3/bin/bbmanedefault.swc -d default
rm catalog.xml
cp native/Device-Debug/libbbm-arm.so ./nativearm.so
cp native/Simulator-Debug/libbbm-x86.so ./nativex86.so
eval $AIR_SDK_PATH/adt -package -target ane bbm.ane extension.xml -swc as3/bin/bbmanedefault.swc -platform QNX-ARM -C . library.swf nativearm.so -platform QNX-x86 -C . library.swf nativex86.so -platform default -C ./default library.swf
rm nativearm.so
rm nativex86.so
rm library.swf
rm -R default
cp bbm.ane ../app