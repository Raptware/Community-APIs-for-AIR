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
	
	/**
	 * NetworkEvents are dispatched as a result of Scoreloop server queries.
	 * Register to Scoreloop classes to catch Network Events. 
	 * @author caneraltinbasak
	 * 
	 */
	public class NetworkEvent extends Event
	{
		
		public static const SUCCESS:String = "NetworkSuccess";
		public static const ERROR:String = "NetworkError";
		/**
		 * Message associated with error. Check this message to 
		 * get detailed information about the error. 
		 */
		public var message:String;
		/**
		 * @private
		 */
		public function NetworkEvent(type:String, message:String)
		{
			super(type, false, false);
			this.message = message;
		}
	}
}