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
	 * The Game class models the game application. 
	 * Games must be registered at <a href="https://developer.scoreloop.com">
	 * https://developer.scoreloop.com</a>, where they are assigned a unique
	 * game-id and game secret, and where you can configure additional game properties.
	 *
	 *
	 * Game provides access to the game identifier and game secret
	 * that were assigned by Scoreloop when you registered the game.
	 * @author caneraltinbasak
	 * 
	 */
	public class Game
	{
		private static var _instance:Game=null;
		private static var allowInstantiation:Boolean = false;

		/**
		 * Do not explicitly call this constructor. You should use Scoreloop.client.game instead of instatiating
		 * it directly. Trying to instantiate directly causes an Error to be thrown.  
		 * 
		 */
		public function Game()
		{
			if(!allowInstantiation)
				throw new Error("Cannot create more than one instance. Access this object through client");
			allowInstantiation=false;
		}
		/**
		 * This method returns the identifier for the current
		 * game instance. The identifier is assigned by Scoreloop
		 * when the game is registered at
		 * <a href="https://developer.scoreloop.com">
		 * https://developer.scoreloop.com</a>.
		 * @return The game identifier field value.
		 * 
		 */
		public function get identifier():String{
			return( String( Scoreloop.EXT.call( "getGameIdentifier") ) );
		}
		/**
		 * This method is an accessor to the Name field. 
		 * @return The name field value.
		 * 
		 */
		public function get name():String{
			return( String( Scoreloop.EXT.call( "getGameName") ) );
		}
		
		internal static function instace():Game
		{
			if(_instance == null){
				allowInstantiation = true;
				_instance = new Game();
			}
			return _instance;
		}
	}
}