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
 * scorescontroller.h
 *
 *  Created on: Oct 14, 2012
 *      Author: caneraltinbasak
 */

#ifndef SCORESCONTROLLER_H_
#define SCORESCONTROLLER_H_
#include "sc_common.h"

FREObject initScoresController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getScores(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadNextRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadPreviousRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject hasNextRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject hasPreviousRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getRange(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadScores(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadScoresAtRank(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadScoresAroundScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadScoresAroundUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);



#endif /* SCORESCONTROLLER_H_ */
