/*
* Copyright (c) 2013 WallWizz 
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
  implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

/*
 * client_ane.c
 *
 *  Created on: Oct 11, 2012
 *      Author: caneraltinbasak
 */
#include "client.h"
#include <stdbool.h>
#include <string.h>

FREObject isSupported(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	bool isSupported = true;
	FREObject result;
	FRENewObjectFromBool( (uint32_t)isSupported, &result );
	return( result );
}
FREObject initSC_Client(FREContext ctx, void* functionData, uint32_t argc,
		FREObject argv[]) {
	FREObject result;
	const uint8_t * aGameId = NULL;
	const uint8_t * aGameSecret = NULL;
	const uint8_t * aGameVersion = NULL;
	const uint8_t * aCurrency = NULL;
	const uint8_t * aLanguageCode = NULL;
	uint32_t length = 0;

	if(argc != 5)
		return 0;

	FREGetObjectAsUTF8(argv[0],&length,&aGameId);
	FREGetObjectAsUTF8(argv[1],&length,&aGameSecret);
	FREGetObjectAsUTF8(argv[2],&length,&aGameVersion);
	FREGetObjectAsUTF8(argv[3],&length,&aCurrency);
	FREGetObjectAsUTF8(argv[4],&length,&aLanguageCode);

	// Initialize scData
	SC_InitData_Init(&scData);

	scData.runLoopType = SC_RUN_LOOP_TYPE_CUSTOM;

	SC_Error_t errCode = SC_Client_New(&client,
			&scData,
			(const char*)aGameId,
			(const char*)aGameSecret,
			(const char*)aGameVersion,
			(const char*)aCurrency,
			(const char*)aLanguageCode);

	bool returnVal = (errCode == SC_OK);
	FRENewObjectFromBool(returnVal,&result);
	return result;
}
FREObject handleSC_Event(FREContext ctx, void* functionData, uint32_t argc,
		FREObject argv[]) {
	SC_HandleCustomEvent(&scData, SC_FALSE); // SC_FALSE will not block here, SC_TRUE will
	return NULL;
}
FREObject releaseSC_Client(FREContext ctx, void* functionData, uint32_t argc,
		FREObject argv[]) {
	SC_Client_Release(client);
	return NULL;
}


