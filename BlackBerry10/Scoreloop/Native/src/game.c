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
 * game.c
 *
 *  Created on: Oct 13, 2012
 *      Author: caneraltinbasak
 */
#include "game.h"
#include <string.h>

FREObject getGameName(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]) {
	FREObject result;
	SC_Game_h aGame = SC_Client_GetGame(client);
	if(aGame == NULL)
	{
		fprintf(stderr, "aGame NULL\n");
		return NULL;
	}
	SC_String_h aName = SC_Game_GetName(aGame);
	if(aName == NULL)
	{
		fprintf(stderr, "aName NULL\n");
		return NULL;
	}
	const char* aNameStr = SC_String_GetData(aName);
	FRENewObjectFromUTF8(strlen(aNameStr)+1,(const uint8_t*)aNameStr,&result);
	return result;
}
FREObject getGameIdentifier(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]) {
	FREObject result;
	if(argc!=0)
		return 0;
	SC_Game_h aGame = SC_Client_GetGame(client);
	SC_String_h aId = SC_Game_GetIdentifier(aGame);
	const char* aIdStr = SC_String_GetData(aId);
	FRENewObjectFromUTF8(strlen(aIdStr)+1,(const uint8_t*)aIdStr,&result);
	return result;
}
