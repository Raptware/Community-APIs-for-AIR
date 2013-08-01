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
 * Copyright (c) 2011 Research In Motion Limited.
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
#include "FlashRuntimeExtensions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "scoreloop_ane.h"


void ExtensionInitializer(void** extDataToSet,
		FREContextInitializer* ctxInitializerToSet,
		FREContextFinalizer* ctxFinalizerToSet);
void ExtensionFinalizer();

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
		uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet);
void ContextFinalizer(FREContext ctx);


/**
 * The runtime calls this method once when it loads an ActionScript extension.
 * Implement this function to do any initializations that your extension requires.
 * Then set the output parameters.
 *
 * @param extDataToSet
 *             A pointer to a pointer to the extension data of the ActionScript extension.
 *             Create a data structure to hold extension-specific data. For example, allocate
 *             the data from the heap, or provide global data. Set extDataToSet to a pointer
 *             to the allocated data.
 * @param ctxInitializerToSet
 *             A pointer to the pointer to the FREContextInitializer() function. Set
 *             ctxInitializerToSet to the FREContextInitializer() function you defined.
 * @param ctxFinalizerToSet
 *             A pointer to the pointer to the FREContextFinalizer() function. Set
 *             ctxFinalizerToSet to the FREContextFinalizer() function you defined. You can
 *             set this pointer to NULL.
 */
void ExtensionInitializer(void** extDataToSet,
		FREContextInitializer* ctxInitializerToSet,
		FREContextFinalizer* ctxFinalizerToSet) {
	*extDataToSet = NULL;
	*ctxInitializerToSet = &ContextInitializer;
	*ctxFinalizerToSet = &ContextFinalizer;
}

/**
 * The runtime calls this function when it disposes of the ExtensionContext instance
 * for this extension context.
 */
void ExtensionFinalizer() {

}

/**
 * The runtime calls this method when the ActionScript side calls ExtensionContext.createExtensionContext().
 *
 * @param extData
 *             A pointer to the extension data of the ActionScript extension.
 * @param ctxType
 *             A string identifying the type of the context. You define this string as
 *             required by your extension. The context type can indicate any agreed-to meaning
 *             between the ActionScript side and native side of the extension. If your extension
 *             has no use for context types, this value can be Null. This value is a UTF-8
 *             encoded string, terminated with the null character.
 * @param ctx
 *             An FREContext variable. The runtime creates this value and passes it to FREContextInitializer().
 * @param numFunctionsToSet
 *             A pointer to a unint32_t. Set numFunctionsToSet to a unint32_t variable containing
 *             the number of functions in the functionsToSet parameter.
 * @param functionsToSet
 *             A pointer to an array of FRNamedFunction elements. Each element contains a pointer
 *             to a native function, and the string the ActionScript side uses in the ExtensionContext
 *             instance's call() method.
 */
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
		uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
	context = ctx;

	static FRENamedFunction s_classMethods[] =
	{
		// Client
		{(const uint8_t *)"isSupported", NULL, isSupported},
		{(const uint8_t *)"initSC_Client", NULL, initSC_Client},
		{(const uint8_t *)"releaseSC_Client", NULL, initSC_Client},
		{(const uint8_t *)"handleSC_Event", NULL, handleSC_Event},

		// Game
		{(const uint8_t *)"getGameName", NULL, getGameName},
		{(const uint8_t *)"getGameIdentifier", NULL, getGameIdentifier},

		// Score Controller
		{(const uint8_t *)"initScoreController", NULL, initScoreController},
		{(const uint8_t *)"submitScore", NULL, submitScore},
		{(const uint8_t *)"getScore", NULL, getScore},

		// Scores Controller
		{(const uint8_t *)"initScoresController", NULL, initScoresController},
		{(const uint8_t *)"setMode", NULL, setMode},
		{(const uint8_t *)"getMode", NULL, getMode},
		{(const uint8_t *)"setSearchList", NULL, setSearchList},
		{(const uint8_t *)"getSearchList", NULL, getSearchList},
		{(const uint8_t *)"getScores", NULL, getScores},
		{(const uint8_t *)"loadNextRange", NULL, loadNextRange},
		{(const uint8_t *)"loadPreviousRange", NULL, loadPreviousRange},
		{(const uint8_t *)"hasNextRange", NULL, hasNextRange},
		{(const uint8_t *)"hasPreviousRange", NULL, hasPreviousRange},
		{(const uint8_t *)"getRange", NULL, getRange},
		{(const uint8_t *)"loadScores", NULL, loadScores},
		{(const uint8_t *)"loadScoresAtRank", NULL, loadScoresAtRank},
		{(const uint8_t *)"loadScoresAroundScore", NULL, loadScoresAroundScore},
		{(const uint8_t *)"loadScoresAroundUser", NULL, loadScoresAroundUser},

		// Ranking Controller
		{(const uint8_t *)"initRankingController", NULL, initRankingController},
		{(const uint8_t *)"setRankingSearchList", NULL, setRankingSearchList},
		{(const uint8_t *)"getRankingSearchList", NULL, getRankingSearchList},
		{(const uint8_t *)"loadRankingForScore", NULL, loadRankingForScore},
		{(const uint8_t *)"loadRankingForCurrentUserInMode", NULL, loadRankingForCurrentUserInMode},
		{(const uint8_t *)"getCurrentRanking", NULL, getCurrentRanking},
		{(const uint8_t *)"getTotalRankings", NULL, getTotalRankings},
		{(const uint8_t *)"getScoreFromRankingController", NULL, getScoreFromRankingController},

		// User Controller
		{(const uint8_t *)"initUserController", NULL, initUserController},
		{(const uint8_t *)"userControllerRequestUser", NULL, userControllerRequestUser},
		{(const uint8_t *)"userControllerGetUser", NULL, userControllerGetUser},
		{(const uint8_t *)"userControllerSetUser", NULL, userControllerSetUser},
		{(const uint8_t *)"userControllerGetValidationErrors", NULL, userControllerGetValidationErrors}
	};

	const int c_methodCount = sizeof(s_classMethods) / sizeof(FRENamedFunction);

	// Update caller with the required data
	*functionsToSet = s_classMethods;
	*numFunctionsToSet = c_methodCount;
	fprintf(stdout,"Exit ContextInitializer");

}

/**
 * The runtime calls this function when it disposes of the ExtensionContext instance for this extension context.
 *
 * @param ctx
 *             The FREContext variable that represents this extension context.
 */
void ContextFinalizer(FREContext ctx) {
	SC_Client_Release(client);
}
