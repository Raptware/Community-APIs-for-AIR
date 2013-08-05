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

package com.wallwizz.scoreloop
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;

	public class RankingController extends EventDispatcher
	{
		private static var _instance:RankingController=null;
		private static var allowInstantiation:Boolean = false;
		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.client.rankingController instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown.  
		 * 
		 */
		public function RankingController()
		{
			if(!allowInstantiation)
				throw new Error("Cannot create more than one instance. Access this object through client");
			Scoreloop.EXT.addEventListener( StatusEvent.STATUS, statusEvent );
			Scoreloop.EXT.call("initRankingController");
			allowInstantiation = false;

		}
		
		internal static function instace():RankingController
		{
			if(_instance == null){
				allowInstantiation = true;
				_instance = new RankingController();
			}
			return _instance;
		}
		protected function statusEvent(event:StatusEvent):void
		{
			if(event.code == "rankingcontroller")
			{
				if(event.level == "SC_OK")
				{
					dispatchEvent(new NetworkEvent(NetworkEvent.SUCCESS,event.level));
				}else
				{
					dispatchEvent(new NetworkEvent(NetworkEvent.ERROR,event.level));
				}
			}
		}
		/**
		 * Not functional at the moment, always uses SC_SCORES_SEARCH_LIST_ALL. 
		 * @param list
		 * 
		 */
		public function set searchList(list:int):void
		{
			Scoreloop.EXT.call( "setRankingSearchList",list);
		}
		/**
		 * @private
		 * 
		 */
		public function get searchList():int
		{
			return Scoreloop.EXT.call( "getRankingSearchList") as int;
		}
		
		/**
		 * Not Implemented. Do NOT USE! 
		 * @param aScore
		 * 
		 */
		private function loadRankingForScore(aScore:Score):void  // Calismiyor sanirim yeni skor girilmemesi gerekiyor. Ptr olmadan olmaz
		{
			Scoreloop.EXT.call( "loadRankingForScore",aScore);
		}
		/**
		 * This method is used to request the ranking of a given user.
		 * Note that this is an asynchronous call and a callback will be triggered after which you could access the retrieved ranking by calling SC_RankingController_GetRanking().
		 * @param aMode The ranking mode
		 * 
		 */
		public function loadRankingForCurrentUserInMode(aMode:int):void
		{
			Scoreloop.EXT.call( "loadRankingForCurrentUserInMode",aMode);
		}
		/**
		 * After a successful server request, use this method to return the 
		 * rank that was requested.  
		 * @return An int corresponding to the rank that was retrieved.
		 * 
		 */
		public function getRanking():int
		{
			return Scoreloop.EXT.call( "getCurrentRanking" ) as int;
		}
		/**
		 * This method is used to get the total number of scores used for ranking purposes. 
		 * @return int corresponding to the total number of scores returned
		 * 
		 */
		public function getTotal():int
		{
			return Scoreloop.EXT.call( "getTotalRankings") as int;
		}
		/**
		 * Method to return the score object associated with a rank/user. 
		 * For example if you want to display the score in addition 
		 * to the rank for a particulat user, you could call this method. 
		 * @return The score object associated with the rank that is retrieved.
		 * 
		 */
		public function getScore():Score
		{
			return Scoreloop.EXT.call( "getScoreFromRankingController") as Score;
		}
	}
}