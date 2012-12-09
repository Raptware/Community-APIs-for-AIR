/*
* Copyright (c) 2012 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
#include <air/FlashRuntimeExtensions.h>
#include <img/img.h>
#include <io/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

img_lib_t s_libImg;

void contextInitializer(void* extData, const uint8_t* ctxType,
		FREContext ctx, uint32_t* numFunctionsToSet,
		const FRENamedFunction** functionsToSet);
void contextFinalizer(FREContext ctx);

static bool
getString(FREObject obj, const char **result)
{
	FREObjectType type;
	uint32_t length;
	const uint8_t  *value;
	if ( FREGetObjectType(obj, &type) == FRE_OK && type == FRE_TYPE_STRING &&
		 FREGetObjectAsUTF8(obj, &length, &value) == FRE_OK )
	{
		*result = (const char *)value;
		return true;
	}
	return false;
}

int
attachLib()
{
	int attach = FRE_OK;
	if( s_libImg == NULL )
	{
		attach = img_lib_attach(&s_libImg);
	}

	return( attach );
}

void getImage( FREObject bd, FREObject hasAlpha, img_t *img )
{
	uint32_t transparent;
	FREGetObjectAsBool( hasAlpha, &transparent );


	FREBitmapData bmpData;
	FREAcquireBitmapData( bd, &bmpData );
	img->flags = IMG_DIRECT | IMG_FORMAT | IMG_W | IMG_H;
	img->w = bmpData.width;
	img->h = bmpData.height;

	img->format = transparent ? IMG_FMT_PKLE_ARGB8888 : IMG_FMT_PKLE_XRGB8888;

	img->access.direct.data = (uint8_t *)bmpData.bits32;
	img->access.direct.stride = bmpData.lineStride32 * 4;

	FREReleaseBitmapData( bd );
}


FREObject
save(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	//args bitmapData, path, transparency

	FREObject result;

	const char *path;
	getString( argv[1], &path );

	int attach = attachLib();
	if( attach != IMG_ERR_OK )
	{
		FRENewObjectFromInt32( (int32_t)attach, &result );
		return result;
	}

	img_t imageInfo;
	memset(&imageInfo, 0, sizeof(imageInfo));

	getImage( argv[0], argv[ 2 ], &imageInfo );

	int write = img_write_file(s_libImg, path, NULL, &imageInfo );

	FRENewObjectFromInt32( (int32_t)write, &result );

	return result;
}






void
contextInitializer(void* extData, const uint8_t* ctxType,
				   FREContext ctx, uint32_t* numFunctionsToSet,
				   const FRENamedFunction** functionsToSet)
{
	static FRENamedFunction s_classMethods[] = {
	    {(const uint8_t*)"save", NULL, save},
	};
	const int c_methodCount = sizeof(s_classMethods) / sizeof(FRENamedFunction);

	*functionsToSet = s_classMethods;
	*numFunctionsToSet = c_methodCount;
}

void
contextFinalizer(FREContext ctx)
{
}


void
extensionInitializer(void** extDataToSet,
					 FREContextInitializer* ctxInitializerToSet,
					 FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &contextInitializer;
	*ctxFinalizerToSet = &contextFinalizer;
}


void
extensionFinalizer()
{
	if( s_libImg != NULL )
	{
		img_lib_detach(s_libImg);
	}
	return;
}
