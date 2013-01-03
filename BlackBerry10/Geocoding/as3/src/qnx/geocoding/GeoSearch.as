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
	import flash.external.ExtensionContext;

	/**
	* The <code>GeoSearch</code> class provides geo-coding and reverse geo-coding capabilities.
	* <p>
	* In order to return successful search results, you must ensure that the application has a data connection.
	* Also, applications need to add the following permission to their bar-descriptor.xml.
	* <permission>access_location_services</permission>
	* </p>
	**/
	public class GeoSearch
	{
		private static var __context:ExtensionContext;
		
		private static function contextCheck():void
		{
			if( __context == null )
			{
				__context = ExtensionContext.createExtensionContext( "qnx.geocoding.QNXGeoSearch", null );
			}
		}
		
		/**
		* Returns a list of locations based on the specified search string.
		* <p>
		* By providing a latitude and longitude, it gives the search a hint as to where you are trying to search. 
		* For example, if you knew you where looking for an address in a specific city, you would want to pass in the coordinates of that city to help narrow the search.
		* If either the <code>latitude</code> or <code>longitude</code> is <code>NaN</code>, the location is not used as a hint.
		* </p>
		* @param search A search string.
		* @param latitude A latitude hint for the search.
		* @param longitude A longitude hint for the search.
		* @return A vector of <code>SearchLocation</code> instances representing each location return by the search.
		* @throws Error - An Error is thrown when an error is returned by the native geo-search library.
		**/
		public static function getSearch( search:String, latitude:Number = NaN, longitude:Number = NaN ):Vector.<SearchLocation>
		{
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				contextCheck();
			
				if( isNaN( latitude ) || isNaN( longitude ) )
				{
					return( getReply( __context.call( "search_geocode", search ) as int ) );
				}
						
				return( getReply( __context.call( "search_geocode_latlon", search, latitude, longitude ) as int ) );
			}
			/*FDT_IGNORE*/
			else
			/*FDT_IGNORE*/
			{
				var results:Vector.<SearchLocation> = new Vector.<SearchLocation>();
				var location:SearchLocation = new SearchLocation();
				location.name = "1001 Farrar Road, Ottawa, ON";
				location.longitude = 45.343665;
				location.latitude = -75.909638;
				location.city = "Ottawa";
				location.street = "Farrar Road";
				location.country = "Canada";
				location.district = "ON";
				location.countryCode2 = "CA";
				location.countryCode3 = "CAN";
				location.countryID = 124;
				results.push( location );
				return( results );
			}
		}
		
		
		private static function getReply( success:int ):Vector.<SearchLocation>
		{
			var results:Vector.<SearchLocation> = new Vector.<SearchLocation>();
			
			if( success != 0 )
			{
				//This is error is for an empty response.
				//No need to throw an error, just return a empty vector.
				if( success == 0x1003 )
				{
					return( results );
				}
				
				var error:String = __context.call( "get_error_string", success ) as String;
				throw new Error( "GeoSearch - " + error, success );
			}
			else
			{
				var length:int = __context.call( "get_replylen" ) as int;
				
				for( var i:int = 0; i<length; i++ )
				{
					var location:SearchLocation = new SearchLocation();
					results.push( location );
				}
				
				__context.call( "get_reply", results );
			}
			
			return( results );
		}
		
		
		
		
	}
}
