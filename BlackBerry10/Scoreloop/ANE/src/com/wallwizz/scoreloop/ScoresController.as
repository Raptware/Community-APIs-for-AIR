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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * Retrieves lists of score objects from the server. 
	 * @author caneraltinbasak
	 * 
	 */
	public class ScoresController extends EventDispatcher
	{
		private static var _instance:ScoresController=null;
		private static var allowInstantiation:Boolean = false;
		public static const SC_SCORE_SEARCH_LIST_GLOBAL:int = 0;
		public static const SC_SCORE_SEARCH_LIST_24H:int = 1;
		public static const SC_SCORE_SEARCH_LIST_USER_COUNTRY:int = 2;
		
		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.client.scoresController instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown.  
		 * 
		 */
		public function ScoresController()
		{
			if(!allowInstantiation)
				throw new Error("Cannot create more than one instance. Access this object through client");
			Scoreloop.EXT.addEventListener( StatusEvent.STATUS, statusEvent );
			Scoreloop.EXT.call("initScoresController");
			allowInstantiation = false;
		}
		
		internal static function instace():ScoresController
		{
			if(_instance == null){
				allowInstantiation = true;
				_instance = new ScoresController();
			}
			return _instance;
		}
		protected function statusEvent(event:StatusEvent):void
		{
			if(event.code == "scorescontroller")
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
		 * Set game mode for scores.
		 * @param modeInt game mode.
		 * 
		 */
		public function set mode(modeInt:int):void
		{
			Scoreloop.EXT.call( "setMode",modeInt);
		}
		/**
		 * @private
		 * 
		 */
		public function get mode():int
		{
			return Scoreloop.EXT.call( "getMode") as int;
		}
		/**
		 * Sets the search list for Scores Controller.
		 * @param list Available search lists: SC_SCORE_SEARCH_LIST_GLOBAL, SC_SCORE_SEARCH_LIST_24H, SC_SCORE_SEARCH_LIST_USER_COUNTRY
		 * 
		 */
		public function set searchList(list:int):void
		{
			Scoreloop.EXT.call( "setSearchList",list);
		}
		/**
		 * @private
		 * 
		 */
		public function get searchList():int
		{
			return Scoreloop.EXT.call( "getSearchList") as int;
		}
		/**
		 * This method returns the list of scores that were
		 * returned by the server. Call this method only
		 * after receiving notification of a successful server
		 * request via delegate callbacks.		 
		 * @param contextKeys If you have recorded any context values with your score, you must enter list of context values.
		 * @return Array of score values
		 * 
		 */
		public function getScores(contextKeys:Array = null):Array
		{
			return Scoreloop.EXT.call( "getScores", contextKeys) as Array;
		}
		/**
		 * Makes an asynchrounous request to load the next range of scores. 
		 * 
		 */
		public function loadNextRange():void
		{
			Scoreloop.EXT.call( "loadNextRange");
		}
		/**
		 * Makes an asynchrounous request to load the previous range of scores.  
		 * 
		 */
		public function loadPreviousRange():void
		{
			Scoreloop.EXT.call( "loadPreviousRange");
		}
		/**
		 * This method checks whether there is a "next range" of scores available from the server. 
		 * This method is used to check whether forward pagination through a list of scores is possible.		 
		 * @return A boolean value indicating whether forward pagination is possible.
		 * 
		 */
		public function hasNextRange():Boolean
		{
			return Scoreloop.EXT.call( "hasNextRange");
		}
		/**
		 * This method checks if a "previous range" of scores is available from the server. 
		 * * This method is used to check whether backward pagination through a list of scores is possible.		 
		 * @return A boolean value indicating if backward pagination is possible.
		 * 
		 */
		public function hasPreviousRange():Boolean
		{
			return Scoreloop.EXT.call( "hasPreviousRange");
		}
		/**
		 * This method returns the position from where the scores are loaded 
		 * using any of the ScoresController's load methods 
		 * @return The range requested to load.
		 * 
		 */
		public function getRange():Range
		{
			return Range(Scoreloop.EXT.call( "getRange"));
		}
		/**
		 * This method requests the list of scores, defined by the supplied range, from the server.
		 * Note that this is an asynchronous call and a callback will be triggered, after which you can access the
		 * retrieved scores by calling getScores().
		 * @param range The starting position and offset of the requested scores range (numbered from 0, the first score to load).
		 * 
		 */
		public function loadScores(range:Range):void
		{
			Scoreloop.EXT.call( "loadScores",range);
		}
		/**
		 * Requests the list beginning at the given rank. The rank refers to a score's position on the global leaderboard. 
		 * All lists start at 1, therefore the minimum rank possible is 1.
		 * Note that this is an asynchronous call and a callback will be triggered, after which you can access the
		 * retrieved scores by calling getScores(). 
		 * @param rank The starting position of the range (numbered from 1, the first score to load).
		 * @param length The length of the range requested.
		 * 
		 */
		public function loadScoresAtRank(rank:int,length:int):void
		{
			Scoreloop.EXT.call( "loadScoresAtRank",rank,length);
		}
		/**
		 * This method returns the list of scores that includes the given score in the middle.
		 * Note that this is an asynchronous call and a callback will be
		 * triggered, after which you can access the retrieved scores by calling getScores(). 
		 * @param length The length of the range requested.
		 * 
		 */
		public function loadScoresAroundUser(length:int):void // limitation: searches only current user
		{
			Scoreloop.EXT.call( "loadScoresAroundUser",length);
		}
	}
}