#!/bin/sh
AIR_SDK_PATH="/Developer/SDKs/air_3.4/bin"

unzip -o ane/bin/ImageSaver.swc
rm catalog.xml
cp native/Device-Debug/libImageSaver-arm.so ./nativearm.so
cp native/Simulator-Debug/libImageSaver-x86.so ./nativex86.so
eval $AIR_SDK_PATH/adt -package -target ane imagesaver.ane native/extension.xml -swc ane/bin/ImageSaver.swc -platform QNX-ARM -C . library.swf nativearm.so -platform QNX-x86 -C . library.swf nativex86.so 
rm nativearm.so
rm nativex86.so
rm library.swf