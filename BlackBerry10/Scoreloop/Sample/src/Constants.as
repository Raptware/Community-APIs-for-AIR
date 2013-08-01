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
	public class Constants
	{
		// scoreloop bitmap mask values for validation errors
		public static const SC_EMAIL_ALREADY_TAKEN:uint = 1;
		public static const SC_EMAIL_FORMAT_INVALID:uint = 2;
		public static const SC_USERNAME_ALREADY_TAKEN:uint = 4;
		public static const SC_USERNAME_FORMAT_INVALID:uint = 8;
		public static const SC_USERNAME_TOO_SHORT:uint = 16;
		public static const SC_IMAGE_TOO_LARGE:uint = 32;
		public static const SC_IMAGE_UNSUPPORTED_MIME_TYPE:uint = 64;
		
		public static const SCORELOOP_STANDART_MODE:int = 2;
		
		public function Constants()
		{
		}
	}
}