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
	 * Common structure to handle range data. It contains offset and length fields. 
	 * @author caneraltinbasak
	 * 
	 */
	public class Range
	{
		private var _start:int;
		private var _length:int;
		/**
		 * This structure describes a data range and is commonly used in all queries, 
		 * @param start Offset of the data. 
		 * @param length Number of records 
		 * 
		 */
		public function Range(start:int,length:int)
		{
			_start = start;
			_length = length;
		}

		/**
		 * Number of records 
		 * 
		 */
		public function get length():int
		{
			return _length;
		}

		/**
		 * Offset of the data. 
		 * 
		 */
		public function get start():int
		{
			return _start;
		}


	}
}