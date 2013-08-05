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
 * rankingcontroller.c
 *
 *  Created on: Oct 20, 2012
 *      Author: caneraltinbasak
 */
#include "rankingcontroller.h"

void rankingControllerCallback(void* userData, SC_Error_t completionStatus);
SC_RankingController_h ranking_controller = NULL;

FREObject initRankingController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Client_CreateRankingController(client, &ranking_controller, rankingControllerCallback, NULL);
	return NULL;
}
FREObject setRankingSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	int aSearchList;
	FREGetObjectAsInt32(argv[0],&aSearchList);
	switch(aSearchList)
	{
	case 0:
#if defined(BB10)
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORES_SEARCH_LIST_ALL);
#else
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORE_SEARCH_LIST_GLOBAL);
#endif
		break;
	case 1:
#if defined(BB10)
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORES_SEARCH_LIST_24H);
#else
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORE_SEARCH_LIST_24H);
#endif
		break;
	case 2:
#if defined(BB10)
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORES_SEARCH_LIST_USER_COUNTRY);
#else
		SC_RankingController_SetSearchList(ranking_controller, SC_SCORE_SEARCH_LIST_USER_COUNTRY);
#endif
		break;
	default:
	    fprintf(stderr, "Invalid  searchlist value: %d\n", aSearchList);
	    break;
	}
	return NULL;
}
FREObject getRankingSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject = NULL;
    //FRENewObjectFromInt32(SC_RankingController_GetSearchList(ranking_controller), &returnObject);
    //TODO: Implement this
    return returnObject;
}
FREObject loadRankingForScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Error_t errCode = NULL;
	SC_Score_h aScore = NULL;

    FREObject freMode;
    FREObject freLevel;
    FREObject freResult;
    FREObject freMinorResult;
    int aMode;
    int aLevel;
    int aResult;
    int aMinorResult;
	FREGetObjectProperty(argv[0],(const uint8_t*)"mode",&freMode,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"level",&freLevel,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"result",&freResult,NULL);
	FREGetObjectProperty(argv[0],(const uint8_t*)"minorResult",&freMinorResult,NULL);

	FREGetObjectAsInt32(freMode,&aMode);
	FREGetObjectAsInt32(freLevel,&aLevel);
	FREGetObjectAsInt32(freResult,&aResult);
	FREGetObjectAsInt32(freMinorResult,&aMinorResult);

	//Step 1
	errCode = SC_Client_CreateScore(client, &aScore);

	//Step 2
	//aResult is the main numerical result achieved by a user in the game.
	SC_Score_SetResult(aScore, aResult);

	//Step 3
	//aMinorResult is the score result of the game
	SC_Score_SetMinorResult(aScore, aMinorResult);
	//aMode is the mode of the game
	SC_Score_SetMode (aScore, aMode);
	//aLevel is the level in the game
	SC_Score_SetLevel (aScore, aLevel);
#if defined(BB10)
	SC_RankingController_LoadRankingForScore(ranking_controller,aScore);
#else
	SC_RankingController_RequestRankingForScore(ranking_controller,aScore);
#endif
	return NULL;
}
FREObject loadRankingForCurrentUserInMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    int aMode;
	SC_Session_h session= SC_Client_GetSession(client);
	SC_User_h aUser = SC_Session_GetUser(session);
	FREGetObjectAsInt32(argv[0],&aMode);
#if defined(BB10)
	SC_RankingController_LoadRankingForUserInMode(ranking_controller,aUser,aMode);
#else
	SC_RankingController_RequestRankingForUserInGameMode(ranking_controller,aUser,aMode);
#endif
	return NULL;
}
FREObject getCurrentRanking(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	unsigned int ranking = SC_RankingController_GetRanking(ranking_controller);
	FRENewObjectFromUint32(ranking,&returnObject);
	return returnObject;
}
FREObject getTotalRankings(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	unsigned int total = SC_RankingController_GetTotal(ranking_controller);
	FRENewObjectFromUint32(total,&returnObject);
	return returnObject;
}
FREObject getScoreFromRankingController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject = 0;
	SC_Score_h aScore = SC_RankingController_GetTotal(ranking_controller);

    FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*5);
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
    FRENewObject("com.wallwizz.scoreloop.User",2,userArgV,&argV[4],NULL);

    FRENewObject("com.wallwizz.scoreloop.Score",5,argV,returnObject,NULL);
    free(argV);
    free(userArgV);
    return returnObject;
}
//Step 6
//To be written by the developer
void rankingControllerCallback(void* userData, SC_Error_t completionStatus) {
	switch(completionStatus){
	case SC_OK:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_OK");
		break;
	case SC_HTTP_SERVER_ERROR:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_HTTP_SERVER_ERROR");
		break;
	case SC_INVALID_RANGE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_INVALID_RANGE");
		break;
	case SC_INVALID_SERVER_RESPONSE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_INVALID_SERVER_RESPONSE");
		break;
	case SC_HANDSHAKE_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_HANDSHAKE_FAILED");
		break;
	case SC_REQUEST_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_REQUEST_FAILED");
		break;
	case SC_REQUEST_CANCELLED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_REQUEST_CANCELLED");
		break;
	case SC_TOO_MANY_REQUETS_QUEUED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_TOO_MANY_REQUETS_QUEUED");
		break;
	case SC_INVALID_GAME_ID:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_INVALID_GAME_ID");
		break;
	default:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"rankingcontroller", (const uint8_t *)"SC_UNKNOWN_ERROR");
		break;
	}
}


