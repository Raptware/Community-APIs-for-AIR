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
 * scorecontroller.c
 *
 *  Created on: Oct 13, 2012
 *      Author: caneraltinbasak
 */

#ifndef SCORECONTROLLER_C_
#define SCORECONTROLLER_C_
#include "scorecontroller.h"
#include <stdio.h>
#include <stdlib.h>

void scoreControllerCallback(void* userData, SC_Error_t completionStatus);
SC_ScoreController_h score_controller = NULL;

FREObject initScoreController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Client_CreateScoreController (client, &score_controller, scoreControllerCallback, NULL);
	return NULL;
}

FREObject submitScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]){
    FREObject returnObject;

	SC_Score_h score = NULL;

	SC_Error_t errCode = NULL;
	int aMode = 0;
	int aLevel = 0;
	double aResult = 0;
	double aMinorResult = 0;

	unsigned int aLength = 0;

    FREObject freMode;
    FREObject freLevel;
    FREObject freResult;
    FREObject freMinorResult;
    FREObject freContextArray;

	FREGetObjectProperty(argv[0],(const uint8_t*)"mode",&freMode,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"level",&freLevel,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"result",&freResult,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"minorResult",&freMinorResult,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"context",&freContextArray,NULL);

	FREGetArrayLength(freContextArray,&aLength);

	FREGetObjectAsInt32(freMode,(int32_t*)&aMode);
	FREGetObjectAsInt32(freLevel,(int32_t*)&aLevel);
	FREGetObjectAsDouble(freResult,&aResult);
	FREGetObjectAsDouble(freMinorResult,&aMinorResult);

	//Step 1
	errCode = SC_Client_CreateScore(client, &score);
	if (errCode != SC_OK){
		fprintf(stderr, "SC_Client_CreateScore err:%d\n",errCode);
	}


	//Step 2
	//aResult is the main numerical result achieved by a user in the game.
	SC_Score_SetResult(score, aResult);
	fprintf(stderr, "SC_Score_SetResult %f\n",aResult);

	//Step 3
	//aMinorResult is the score result of the game
	SC_Score_SetMinorResult(score, aMinorResult);
	//aMode is the mode of the game
	SC_Score_SetMode (score, aMode);
	//aLevel is the level in the game
	SC_Score_SetLevel (score, aLevel);

	int i;
	for(i = 0 ; i < aLength; i++)
	{
		FREObject freContextObject;
		FREObject freKey;
		FREObject freValue;
		SC_Context_h aContext= 0;
		unsigned int length=0;
		const char* aKey;
		SC_String_h scValue;
		const char* aValue;
		FREGetArrayElementAt(freContextArray, i, &freContextObject);
		FREGetObjectProperty(freContextObject,(const uint8_t*)"key",&freKey,NULL);
		FREGetObjectProperty(freContextObject,(const uint8_t*)"value",&freValue,NULL);
		FREGetObjectAsUTF8(freKey,&length,(const uint8_t**)&aKey);
		FREGetObjectAsUTF8(freValue,&length,(const uint8_t**)&aValue);
		SC_String_New(&scValue,aValue);
		SC_Context_New(&aContext);
	    fprintf(stderr, "recorded aKey: %s\n", aKey);
	    fprintf(stderr, "recorded aValue: %s\n", aValue);
		if(SC_Context_Put(aContext,aKey,scValue)!=SC_OK)
			fprintf(stderr, "SC_Context_Put Error\n");
		if(SC_Score_SetContext(score,aContext) != SC_OK)
			fprintf(stderr, "SC_Score_SetContext Error\n");

	}

	//Step 5
	if(SC_ScoreController_SubmitScore(score_controller, score)!=SC_OK)
		fprintf(stderr, "SC_ScoreController_SubmitScore Error\n");
	fprintf(stderr, "SC_ScoreController_SubmitScore Success\n");
	return NULL;
}

//Step 6
//To be written by the developer
void scoreControllerCallback(void* userData, SC_Error_t completionStatus) {
	switch(completionStatus){
	case SC_OK:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_OK");
		break;
	case SC_HTTP_SERVER_ERROR:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_HTTP_SERVER_ERROR");
		break;
	case SC_INVALID_RANGE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_INVALID_RANGE");
		break;
	case SC_INVALID_SERVER_RESPONSE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_INVALID_SERVER_RESPONSE");
		break;
	case SC_HANDSHAKE_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_HANDSHAKE_FAILED");
		break;
	case SC_REQUEST_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_REQUEST_FAILED");
		break;
	case SC_REQUEST_CANCELLED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_REQUEST_CANCELLED");
		break;
	case SC_TOO_MANY_REQUETS_QUEUED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_TOO_MANY_REQUETS_QUEUED");
		break;
	case SC_INVALID_GAME_ID:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_INVALID_GAME_ID");
		break;
	default:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorecontroller", (const uint8_t *)"SC_UNKNOWN_ERROR");
		break;
	}
}

FREObject getScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]){

	SC_Score_h score = SC_ScoreController_GetScore(score_controller);
	if(score == NULL){
	    fprintf(stderr, "score == NULL\n");
		return NULL;
	}

    FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*5);
    FREObject returnObject;
    FRENewObjectFromInt32(SC_Score_GetMode(score), &argV[0]);
    FRENewObjectFromInt32(SC_Score_GetLevel(score), &argV[1]);
    FRENewObjectFromDouble(SC_Score_GetResult(score), &argV[2]);
    FRENewObjectFromDouble(SC_Score_GetMinorResult(score), &argV[3]);

    // Create the 5th argument(User)
    SC_User_h aUser = SC_Score_GetUser(score);
    if(aUser == NULL){
	    fprintf(stderr, "aUser == NULL\n");
		return NULL;
    }
    SC_String_h scLogin = SC_User_GetLogin(aUser);
    SC_String_h scEmail = SC_User_GetEmail(aUser);
    const char * login = "";
    const char * email = "";
    if(scLogin != NULL)
    	login= SC_String_GetData(scLogin);
    if(scEmail != NULL)
    	email = SC_String_GetData(scEmail);

    FREObject* userArgV=(FREObject*)malloc(sizeof(FREObject)*2);
    FRENewObjectFromUTF8(strlen(login)+1,(const uint8_t*)login, &userArgV[0]);
    FRENewObjectFromUTF8(strlen(email)+1,(const uint8_t*)email, &userArgV[1]);
    FRENewObject("com.wallwizz.scoreloop.User",2,userArgV,&argV[4],NULL);
    free(userArgV);


	if(FRENewObject("com.wallwizz.scoreloop.Score",5,argV,&returnObject,NULL) == FRE_OK)
	{
		free(argV);
		return returnObject;
	}
	else
	{
		free(argV);
		return NULL;
	}
}

#endif /* SCORECONTROLLER_C_ */
