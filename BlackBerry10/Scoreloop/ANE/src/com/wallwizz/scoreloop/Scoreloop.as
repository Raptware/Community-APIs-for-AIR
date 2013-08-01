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
	import flash.external.ExtensionContext;

	/**
	 * Main entry point for Scoreloop library. Creating an instance of Scoreloop is not allowed.
	 * Use its static functions instead.
	 * Use isSupported() function to see if Scoreloop is supported on your system.
	 * If Scoreloop is supported, you can use createClient and create an instance of
	 * Client. Only one client can be created per session. Rest of the API will be accessed through
	 * this client after creating it. Keep the instance of Client after creating it.
	 * @author caneraltinbasak
	 * 
	 */
	public class Scoreloop
	{
		internal static const EXT:ExtensionContext = ExtensionContext.createExtensionContext( "com.wallwizz.scoreloopane", null );
		/**
		 * Creating an instance of Scoreloop objects causes an Error to be thrown. 
		 * Do not create an instance of Scoreloop. Use its static classes. 
		 * 
		 */
		public function Scoreloop()
		{
			throw new Error("Do not create an instance of Scoreloop.");
		}
		/**
		 * Checks if Scoreloop is supported on the device. 
		 * @return 
		 * 
		 */
		public static function isSupported():Boolean
		{
			return( Boolean( EXT.call( "isSupported") ) );
		}
		/**
		 * Creates a scoreloop client. You can keep a reference to this client and you can only access Scoreloop api through
		 * this client. It is not possible to create more than one client.  
		 * @param aGameId Game ID provided by Scoreloop.
		 * @param aGameSecret Game Secret provided by Scoreloop.
		 * @param aGameVersion Game Version should be equal or larger than the version entered while creating the game in Scoreloop server.
		 * @param aCurrency In game currency.
		 * @param aLanguageCode Game language.
		 * @return Scoreloop Client.
		 * 
		 */
		public static function createClient(aGameId:String, aGameSecret:String, aGameVersion:String, aCurrency:String, aLanguageCode:String):Client
		{
			return Client.create(aGameId,aGameSecret,aGameVersion,aCurrency,aLanguageCode);
		}
	}
}