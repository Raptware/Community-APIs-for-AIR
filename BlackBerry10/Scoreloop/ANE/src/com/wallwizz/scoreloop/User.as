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
	/**
	 * Models the game user. 
	 * @author caneraltinbasak
	 * 
	 */
	public class User
	{
		private var _login:String;
		private var _email:String;
		/**
		 * Models the game user. 
		 * @param login Username of the User
		 * @param email Email of the User
		 * 
		 */
		public function User(login:String,email:String)
		{
			_login = login;
			_email = email;
		}

		/**
		 * Username of the User 
		 * 
		 */
		public function get login():String
		{
			return _login;
		}

		/**
		 * @private 
		 * 
		 */
		public function set login(value:String):void
		{
			_login = value;
		}

		/**
		 * Email of the User 
		 * 
		 */
		public function get email():String
		{
			return _email;
		}

		/**
		 * @private 
		 * 
		 */
		public function set email(value:String):void
		{
			_email = value;
		}


	}
}