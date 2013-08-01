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

package
{
	import com.wallwizz.scoreloop.Client;
	import com.wallwizz.scoreloop.NetworkEvent;
	import com.wallwizz.scoreloop.Scoreloop;
	
	import flash.events.EventDispatcher;
	
	public class ScoreloopController extends EventDispatcher
	{
		// Singleton object
		private static var instance:ScoreloopController;
		private static var allowInstantiation:Boolean = true; // private constructor is not allowed in ecmascript standart this is a hack method to provide singleton funtionality
		
		private var _client:Client;
		
		public function ScoreloopController()
		{
			if(!allowInstantiation) 
			{
				throw new Error("Error: Instantiation failed: Use ScoreloopController.getInstance() instead of new.");
			}
			
			allowInstantiation = false;
		}
		
		public static function getInstance() : ScoreloopController 
		{
			if (instance == null) 
			{
				instance = new ScoreloopController();
				instance.initScoreloop();
				allowInstantiation = false;
			}
			return instance;
		}
		
		private function initScoreloop():void
		{
			if(Scoreloop.isSupported())
			{
				
				_client = Scoreloop.createClient("e37d8df2-a126-41e9-9382-a4f737f9c5cb",
					"LKWLYpyCy8MjOLBVXha5XGUftOFibfWW7H9aWm6G85K5XSwxe1ALFg==",
					"1.0", 
					"GHD",
					"en");
			}
		}
		
		public function get client():Client
		{
			return _client;
		}
	}
}