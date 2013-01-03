/*
* Copyright (c) 2013 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package qnx.geocoding
{
	import flash.display.Sprite;


	public class Main extends Sprite
	{
		public function Main()
		{

			//45.4214° N, 75.6919° W
			var results:Vector.<SearchLocation>;
			try
			{
				results = GeoSearch.getSearch( "1001 Farrar Road", 45.4214, -75.6919 );
			}
			catch( e:Error )
			{
				trace( e.message );		
			}
			
			if( results )
			{
				for( var i:int = 0; i<results.length; i++ )
				{
					trace( results[ i ] );
				}
			}
		}
	}
}
