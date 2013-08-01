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
 * scorescontroller.c
 *
 *  Created on: Oct 14, 2012
 *      Author: caneraltinbasak
 */
#include "scorescontroller.h"
#include <stdbool.h>


void scoresControllerCallback(void* userData, SC_Error_t completionStatus);

SC_ScoresController_h scores_controller = NULL;
FREObject initScoresController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Client_CreateScoresController (client, &scores_controller, scoresControllerCallback, NULL);
	return NULL;
}
FREObject setMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

	int aMode = 0;
	FREGetObjectAsInt32(argv[0],&aMode);
	SC_ScoresController_SetMode(scores_controller, aMode);
	return NULL;
}
FREObject getMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

    FREObject returnObject;
    FRENewObjectFromInt32(SC_ScoresController_GetMode(scores_controller), &returnObject);
    return returnObject;
}
FREObject setSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	int aSearchList;
	FREGetObjectAsInt32(argv[0],&aSearchList);
	switch(aSearchList)
	{
	case 0:
#if defined(BB10)
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORES_SEARCH_LIST_ALL);
#else
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORE_SEARCH_LIST_GLOBAL);
#endif
		break;
	case 1:
#if defined(BB10)
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORES_SEARCH_LIST_24H);
#else
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORE_SEARCH_LIST_24H);
#endif
		break;
	case 2:
#if defined(BB10)
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORES_SEARCH_LIST_USER_COUNTRY);
#else
		SC_ScoresController_SetSearchList(scores_controller, SC_SCORE_SEARCH_LIST_USER_COUNTRY);
#endif
		break;
	default:
	    fprintf(stderr, "Invalid  searchlist value: %d\n", aSearchList);
	    break;
	}
	return NULL;
}
FREObject getSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
    //FRENewObjectFromInt32(SC_ScoresController_GetSearchList(scores_controller), &returnObject);
    //TODO: Implement this
    return returnObject;
}
FREObject getScores(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_ScoreList_h score_list;
	SC_Score_h aScore;
    FREObject returnObject;
    int i,j;
    unsigned int contextArrayLength = 0;
	FREGetArrayLength(argv[0],&contextArrayLength);

	score_list = SC_ScoresController_GetScores(scores_controller);
	// arrayArgs has the Array arguments.
#if defined(BB10)
	unsigned int scoreListSize = SC_ScoreList_GetCount(score_list);
#else
	unsigned int scoreListSize = SC_ScoreList_GetScoresCount(score_list);
#endif

    FREObject* arrayArgs = (FREObject*)malloc(sizeof(FREObject)*scoreListSize);

	for(i = 0 ; i < scoreListSize ; i++)
	{
#if defined(BB10)
		aScore = SC_ScoreList_GetAt(score_list,i);
#else
		aScore = SC_ScoreList_GetScore(score_list,i);
#endif
	    FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*6);
	    FRENewObjectFromInt32(SC_Score_GetMode(aScore), &argV[0]);
	    FRENewObjectFromInt32(SC_Score_GetLevel(aScore), &argV[1]);
	    FRENewObjectFromDouble(SC_Score_GetResult(aScore), &argV[2]);
	    FRENewObjectFromDouble(SC_Score_GetMinorResult(aScore), &argV[3]);

	    // Create the 5th argument(User)
	    SC_User_h aUser = SC_Score_GetUser(aScore);
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
	    fprintf(stderr, "username: %s\n", login);

	    FRENewObject((const uint8_t*)"com.wallwizz.scoreloop.User",2,userArgV,&argV[4],NULL);

	    // Create the 6th argument(Context)
	    FREObject* contextArray = (FREObject*)malloc(sizeof(FREObject)*contextArrayLength);
	    for(j = 0; j < contextArrayLength; j++)
	    {
		    FREObject context;
			FREObject freContextKey;
			const char * aKey = "test";
			SC_String_h scValue = NULL;
			const char* aValue = NULL;
			unsigned int length;
			FREGetArrayElementAt(argv[0], j, &freContextKey);

			if(FREGetObjectAsUTF8(freContextKey,&length,(const uint8_t**)&aKey) != FRE_OK)
				fprintf(stderr, "FREGetArrayElementAt Error\n");

		    fprintf(stderr, "retrieved aKey: %s\n", aKey);
			SC_Context_h aContext = SC_Score_GetContext(aScore);
			SC_Context_Get(aContext, aKey, &scValue);
		    if(scValue != NULL)
		    {
		    	aValue= SC_String_GetData(scValue);
		    }else{
			    fprintf(stderr, "scValue NULL\n");
			    aValue = "not found";
		    }
		    fprintf(stderr, "retrieved aValue: %s\n", aValue);

		    FREObject* contextArgv=(FREObject*)malloc(sizeof(FREObject)*2);
		    FRENewObjectFromUTF8(strlen(aKey)+1,(const uint8_t*)aKey, &contextArgv[0]);
		    FRENewObjectFromUTF8(strlen(aValue)+1,(const uint8_t*)aValue, &contextArgv[1]);
		    FRENewObject((const uint8_t*)"com.wallwizz.scoreloop.Context",2,contextArgv,&contextArray[j],NULL);
		    free(contextArgv);
	    }
	    FRENewObject((const uint8_t*)"Array",contextArrayLength,contextArray,&argV[5],NULL);

	    FRENewObject((const uint8_t*)"com.wallwizz.scoreloop.Score",6,argV,&arrayArgs[i],NULL);
	    free(contextArray);
	}
    FRENewObject((const uint8_t*)"Array",scoreListSize,arrayArgs,&returnObject,NULL);
    free(arrayArgs);
    return returnObject;
}
FREObject loadNextRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_ScoresController_LoadNextRange(scores_controller);
	return NULL;
}
FREObject loadPreviousRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_ScoresController_LoadPreviousRange(scores_controller);

}
FREObject hasNextRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	FRENewObjectFromBool(SC_ScoresController_HasNextRange(scores_controller),&returnObject);
	return returnObject;
}
FREObject hasPreviousRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	FRENewObjectFromBool(SC_ScoresController_HasPreviousRange(scores_controller),&returnObject);
	return returnObject;
}
FREObject getRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
    FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*2);
#if defined(BB10)
	SC_Range_t aRange = SC_ScoresController_GetRange(scores_controller);
    FRENewObjectFromInt32(SC_Score_GetMode(aRange.offset), &argV[0]);
    FRENewObjectFromInt32(SC_Score_GetLevel(aRange.length), &argV[1]);
#else
    argV[0] = SC_ScoresController_GetRangeOffset(scores_controller);
    argV[1] = SC_ScoresController_GetRangeLength(scores_controller);
#endif

    FRENewObject("com.wallwizz.scoreloop.Range",2,argV,&returnObject,NULL);
    return returnObject;
}
FREObject loadScores(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject start=0,length=0;
	int aStart=0,aLength=0;
	FREGetObjectProperty(argv[0],(const uint8_t*)"start",start,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"length",length,NULL);
	FREGetObjectAsInt32(start,&aStart);
	FREGetObjectAsInt32(length,&aLength);
#if defined(BB10)
	SC_Range_t aRange = {aStart,aLength};
	SC_ScoresController_LoadScores(scores_controller,aRange); // TODO: This is different in bb10, there is a range object
#else
	SC_ScoresController_LoadRange(scores_controller,aStart,aLength);
#endif
	return NULL;
}
FREObject loadScoresAtRank(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	int aRank,aLength;
	FREGetObjectAsInt32(argv[0],&aRank);
	FREGetObjectAsInt32(argv[1],&aLength);
#if defined(BB10)
	SC_ScoresController_LoadScoresAtRank(scores_controller,aRank,aLength);
#else
	SC_ScoresController_LoadRangeAtRank(scores_controller,aRank,aLength);
#endif
	return NULL;
}
FREObject loadScoresAroundUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Session_h session= SC_Client_GetSession(client);
	SC_User_h aUser = SC_Session_GetUser(session);
	int aRange;
	FREGetObjectAsInt32(argv[0],&aRange);
#if defined(BB10)
	SC_ScoresController_LoadScoresAroundUser(scores_controller,aUser,aRange);
#else
	SC_ScoresController_LoadRangeForUser(scores_controller,aUser,aRange);
#endif
	return NULL;
}
FREObject loadScoresAroundScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	return NULL;
}
//Step 6
//To be written by the developer
void scoresControllerCallback(void* userData, SC_Error_t completionStatus) {
	switch(completionStatus){
	case SC_OK:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_OK");
		break;
	case SC_HTTP_SERVER_ERROR:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_HTTP_SERVER_ERROR");
		break;
	case SC_INVALID_RANGE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_INVALID_RANGE");
		break;
	case SC_INVALID_SERVER_RESPONSE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_INVALID_SERVER_RESPONSE");
		break;
	case SC_HANDSHAKE_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_HANDSHAKE_FAILED");
		break;
	case SC_REQUEST_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_REQUEST_FAILED");
		break;
	case SC_REQUEST_CANCELLED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_REQUEST_CANCELLED");
		break;
	case SC_TOO_MANY_REQUETS_QUEUED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_TOO_MANY_REQUETS_QUEUED");
		break;
	case SC_INVALID_GAME_ID:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_INVALID_GAME_ID");
		break;
	default:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"scorescontroller", (const uint8_t *)"SC_UNKNOWN_ERROR");
		break;
	}
}
