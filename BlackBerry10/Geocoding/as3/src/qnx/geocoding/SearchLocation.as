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
	/**
	 * The <code>SearchLocation</code> class represents a location returned in a geo code search.
	 * Not all properties are guaranteed to populated.
	 */
	public class SearchLocation
	{
		
		/** The name of the location. **/
		public var name:String;
		/** The latitude of the location. **/
		public var latitude:Number;
		/** The longitude of the location. **/
		public var longitude:Number;
		/** The description of the location. **/
		public var description:String;
		/** The street of the location. **/
		public var street:String;
		/** The city of the location. **/
		public var city:String;
		/** The region of the location. **/
		public var region:String;
		/** The county of the location. **/
		public var county:String;
		/** The district of the location. **/
		public var district:String;
		/** The country of the location. **/
		public var country:String;
		/** The postal code of the location. **/
		public var postalCode:String;
		/** The mobile cellular code of the location. 
		* @default -1
		**/
		public var mcc:int = -1;
		/** The timezone of the location. **/
		public var timezone:String;
		/** The 2 character country code of the location. **/
		public var countryCode2:String;
		/** The 3 character country code of the location. **/
		public var countryCode3:String;
		/** The country id of the location. **/
		public var countryID:int;
		
		/**
		* Creates a <code>SearchLocation</code> instance.
		**/
		public function SearchLocation()
		{
			
		}
		
		/**
		* @private
		**/
		public function toString() : String
		{
			var str : String = "name=" + name + ",";
						str += "latitude=" + latitude + ",";
						str += "longitude=" + longitude + ",";
						str += "description=" + description + ",";
						str += "street=" + street + ",";
						str += "city=" + city + ",";
						str += "region=" + region + ",";
						str += "county=" + county + ",";
						str += "district=" + district + ",";
						str += "country=" + country + ",";
						str += "postalCode=" + postalCode + ",";
						str += "mcc=" + mcc + ",";
						str += "timezone=" + timezone + ",";
						str += "countryCode2=" + countryCode2 + ",";
						str += "countryCode3=" + countryCode3 + ",";
						str += "countryID=" + countryID;

			return( str );
		}
		
		
	}
}
