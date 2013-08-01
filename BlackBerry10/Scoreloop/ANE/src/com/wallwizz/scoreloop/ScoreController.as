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
	import flash.external.ExtensionContext;


	/**
	 * The Controller is used to submit a score to the servers
	 * @author caneraltinbasak
	 * 
	 */
	public class ScoreController extends EventDispatcher
	{
		private static var _instance:ScoreController=null;
		private static var allowInstantiation:Boolean = false;
		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.client.scoreController instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown.  
		 * 
		 */
		public function ScoreController()
		{
			if(!allowInstantiation)
				throw new Error("Cannot create more than one instance. Access this object through client");
			Scoreloop.EXT.call( "initScoreController");
			Scoreloop.EXT.addEventListener( StatusEvent.STATUS, statusEvent );
			allowInstantiation = false;

		}		
		internal static function instace():ScoreController
		{
			if(_instance == null){
				allowInstantiation = true;
				_instance = new ScoreController();
			}
			return _instance;
		}
		protected function statusEvent(event:StatusEvent):void
		{
			if(event.code == "scorecontroller")
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
		 * This method is used to submit a score to the server.
		 * Note that this is an asynchronous call, and a callback will be triggered upon success or failure 
		 * @param score The score that is to be submitted.
		 * 
		 */
		public function submitScore(score:Score):void
		{
			Scoreloop.EXT.call( "submitScore",score);
		}
		/**
		 * Provides access to the last score that was submitted. 
		 * @return Score object that was submitted using the submitScore method.
		 * 
		 */
		public function getScore():Score{
			return Scoreloop.EXT.call( "getScore") as Score;
		}
	}
}