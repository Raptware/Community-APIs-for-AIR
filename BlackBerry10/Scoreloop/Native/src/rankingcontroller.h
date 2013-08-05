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
 * rankingcontroller.h
 *
 *  Created on: Oct 20, 2012
 *      Author: caneraltinbasak
 */

#ifndef RANKINGCONTROLLER_H_
#define RANKINGCONTROLLER_H_
#include "sc_common.h"

FREObject initRankingController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setRankingSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getRankingSearchList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadRankingForScore(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadRankingForCurrentUser(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject loadRankingForCurrentUserInMode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getCurrentRanking(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getTotalRankings(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getScoreFromRankingController(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);

#endif /* RANKINGCONTROLLER_H_ */
