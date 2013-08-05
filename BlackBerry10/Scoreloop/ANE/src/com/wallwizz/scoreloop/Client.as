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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	 	
	/**
	 * Client is the main entry point for scoreloop ANE. 
	 * Keep the instance of Client after creating it. You can access all the Scoreloop functionality
	 * through this client object. Do not try instantiating instances of other Scoreloop classes.
	 * @author caneraltinbasak
	 * 
	 */
	public class Client
	{
		private static var createdByScoreloop:Boolean=false;
		private var scEventTimer:Timer;
		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.createClient() API instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown. 
		 * @param aGameId
		 * @param aGameSecret
		 * @param aGameVersion
		 * @param aCurrency
		 * @param aLanguageCode
		 * 
		 */
		public function Client(aGameId:String, aGameSecret:String, aGameVersion:String, aCurrency:String, aLanguageCode:String)
		{
			if(!createdByScoreloop)
				throw new Error("Use Scoreloop class to create an instance of Client");
			Scoreloop.EXT.call("initSC_Client",aGameId,aGameSecret,aGameVersion,aCurrency,aLanguageCode);

			scEventTimer = new Timer(100);
			scEventTimer.addEventListener(TimerEvent.TIMER,handeSCEvents);
			scEventTimer.start();
		}
		internal static function create(aGameId:String, aGameSecret:String, aGameVersion:String, aCurrency:String, aLanguageCode:String):Client{
			if(createdByScoreloop)
				throw new Error("Do not create more than one client instance");
			createdByScoreloop=true;
			return new Client(aGameId,aGameSecret,aGameVersion,aCurrency,aLanguageCode);
		}
		protected function handeSCEvents(event:TimerEvent):void
		{
			Scoreloop.EXT.call("handleSC_Event");
		}
		/**
		 * Releases Client and Scoreloop related other resources. 
		 * 
		 */
		public function release():void
		{
			scEventTimer.stop();
			scEventTimer = null;
			Scoreloop.EXT.call("releaseSC_Client");  
		}
		
		
		/**
		 * Access to Game properties 
		 * @return Game object
		 * 
		 */
		public function get game():Game{
			return Game.instace();
		}
		/**
		 * Use this to access score controller object. 
		 * @return instance of ScoreController object
		 * 
		 */
		public function get scoreController():ScoreController{
			return ScoreController.instace();
		}
		/**
		 * Use this to access scores controller(query scores etc.)  
		 * @return instance of ScoresController
		 * 
		 */
		public function get scoresController():ScoresController{
			return ScoresController.instace();
		}
		/**
		 * Use this to acces RankingController object
		 * @return instance of RankingController
		 * 
		 */
		public function get rankingController():RankingController{
			return RankingController.instace();
		}
		/**
		 * Use this to acces UserController object 
		 * @return instance of UserController
		 * 
		 */
		public function get userController():UserController{
			return UserController.instace();
		}
	}
}
