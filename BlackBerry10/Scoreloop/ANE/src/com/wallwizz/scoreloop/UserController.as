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


	/**
	 * The data controller to query and change a user's details. 
	 * @author caneraltinbasak
	 * 
	 */
	public class UserController extends EventDispatcher
	{
		private static var _instance:UserController=null;
		private static var allowInstantiation:Boolean = false;
		
		// scoreloop bitmap mask values for validation errors
		public static const SC_EMAIL_ALREADY_TAKEN:uint = 1;
		public static const SC_EMAIL_FORMAT_INVALID:uint = 2;
		public static const SC_USERNAME_ALREADY_TAKEN:uint = 4;
		public static const SC_USERNAME_FORMAT_INVALID:uint = 8;
		public static const SC_USERNAME_TOO_SHORT:uint = 16;
		public static const SC_IMAGE_TOO_LARGE:uint = 32;
		public static const SC_IMAGE_UNSUPPORTED_MIME_TYPE:uint = 64;
		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.client.userController instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown.  
		 * 
		 */
		public function UserController()
		{
			if(!allowInstantiation)
				throw new Error("Cannot create more than one instance. Access this object through client");
			Scoreloop.EXT.addEventListener( StatusEvent.STATUS, statusEvent );
			Scoreloop.EXT.call("initUserController");
			allowInstantiation = false;
		}
		internal static function instace():UserController
		{
			if(_instance == null){
				allowInstantiation = true;
				_instance = new UserController();
			}
			return _instance;
		}
		protected function statusEvent(event:StatusEvent):void
		{
			if(event.code == "usercontroller")
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
		 * Attributes for the current
		 * session user will be requested. Note that this is an asynchronous call and a callback will be
		 * triggered, after which you can access the retrieved user by calling getUser(). 
		 * 
		 */
		public function requestCurrentUser():void
		{
			Scoreloop.EXT.call( "userControllerRequestUser");
		}
		/**
		 * Get attributes for the current session user 
		 * @return current session user
		 * 
		 */
		public function getUser():User
		{
			return Scoreloop.EXT.call( "userControllerGetUser") as User;
		}
		/**
		 * Sets a new username for current user. 
		 * @param userName User name to be set.
		 * 
		 */
		public function setUserName(userName:String):void
		{
			Scoreloop.EXT.call( "userControllerSetUser", userName);
		}
		/**
		 * Returns the validation errors that occurred while updating the user data. 
		 * @return Possible return types are SC_USERNAME_ALREADY_TAKEN, SC_USERNAME_FORMAT_INVALID
		 * 
		 */
		public function getValidationErrors():int
		{
			return Scoreloop.EXT.call( "userControllerGetValidationErrors") as int;
		}
	}
}