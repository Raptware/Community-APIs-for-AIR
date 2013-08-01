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
 * usercontroller.c
 *
 *  Created on: Oct 20, 2012
 *      Author: caneraltinbasak
 */
#include "usercontroller.h"

void userControllerCallback(void* userData, SC_Error_t completionStatus);
SC_UserController_h user_controller = NULL;

FREObject initUserController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	SC_Client_CreateUserController(client, &user_controller, userControllerCallback, NULL);
	return NULL;
}
FREObject userControllerRequestUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
#if defined(BB10)
	SC_UserController_LoadUser(user_controller);
#else
	SC_UserController_RequestUser(user_controller);
#endif
	return NULL;
}
FREObject userControllerGetUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	SC_User_h aUser = SC_UserController_GetUser(user_controller);
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
    FRENewObject("com.wallwizz.scoreloop.User",2,userArgV,&returnObject,NULL);
    return returnObject;
}
FREObject userControllerSetUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	unsigned int length;
	const char * aLogin = NULL;
	if(FREGetObjectAsUTF8(argv[0],&length,&aLogin) != FRE_OK)
		fprintf(stderr, "FREGetObjectAsUTF8 Error\n");

	SC_User_h aUser = SC_UserController_GetUser(user_controller);
	if(SC_User_SetLogin(aUser, aLogin) != SC_OK)
		fprintf(stderr, "SC_User_SetLogin Error\n");
	if(SC_UserController_UpdateUser(user_controller) != SC_OK)
		fprintf(stderr, "SC_UserController_UpdateUser Error\n");
	return NULL;
}
FREObject userControllerGetValidationErrors(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject returnObject;
	SC_UserValidationError_t vError = SC_UserController_GetValidationErrors(user_controller);
	FRENewObjectFromUint32((uint32_t)vError,&returnObject);
	return returnObject;
}
void userControllerCallback(void* userData, SC_Error_t completionStatus) {
	switch(completionStatus){
	case SC_OK:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_OK");
		break;
	case SC_HTTP_SERVER_ERROR:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_HTTP_SERVER_ERROR");
		break;
	case SC_INVALID_RANGE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_INVALID_RANGE");
		break;
	case SC_INVALID_SERVER_RESPONSE:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_INVALID_SERVER_RESPONSE");
		break;
	case SC_HANDSHAKE_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_HANDSHAKE_FAILED");
		break;
	case SC_REQUEST_FAILED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_REQUEST_FAILED");
		break;
	case SC_REQUEST_CANCELLED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_REQUEST_CANCELLED");
		break;
	case SC_TOO_MANY_REQUETS_QUEUED:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_TOO_MANY_REQUETS_QUEUED");
		break;
	case SC_INVALID_GAME_ID:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_INVALID_GAME_ID");
		break;
	case SC_INVALID_USER_DATA:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_INVALID_USER_DATA");
		break;
	case SC_CONTEXT_VERSION_MISMATCH:   /**< Could not update old user context. */
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_CONTEXT_VERSION_MISMATCH");
		break;
	case SC_INVALID_USER_IMAGE_FORMAT:  /**< Provided image isn't proper JPEG nor PNG file */
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_INVALID_USER_IMAGE_FORMAT");
		break;
	default:
		FREDispatchStatusEventAsync(context, (const uint8_t *)"usercontroller", (const uint8_t *)"SC_UNKNOWN_ERROR");
		break;
	}
}
