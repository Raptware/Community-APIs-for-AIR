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
	 * Class used to represent arbitrary score data (context). 
	 * @author caneraltinbasak
	 * 
	 */
	public class Context
	{
		private var _key:String;
		private var _value:String;
		/**
		 *  Context Constructor
		 * @param key Key value for the context variable
		 * @param value Value of the context variable
		 * 
		 */
		public function Context(key:String, value:String)
		{
			_key = key;
			_value = value;
		}

		/**
		 * Key value for the recorded context 
		 */
		public function get key():String
		{
			return _key;
		}

		/**
		 * @private 
		 * 
		 */
		public function set key(value:String):void
		{
			_key = value;
		}

		/**
		 * Value for the recorded context. 
		 * 
		 */
		public function get value():String
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:String):void
		{
			_value = value;
		}


	}
}