/*
* Copyright (c) 2012 Research In Motion Limited.
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
package qnx.images
{
	
	import flash.external.ExtensionContext;
	import flash.display.BitmapData;
	/**
	 * The ImageSaver class provides methods to save a <code>BitmapData</code> instance to a file on disk.
	 */
	public class ImageSaver
	{
		
		private var __extension:ExtensionContext;
		
		/**
		* Creates a <code>ImageSaver</code> instance.
		**/
		public function ImageSaver()
		{
			
		}
		
		/**
		* Creates the ExtensionContext if it doesn't already exist.
		**/
		private function init():void
		{
			if( __extension == null )
			{
				__extension = ExtensionContext.createExtensionContext("qnx.media.ImageSaver", null);
			}
		}
		
		/**
		* Saves the image synchronously to the specified path.
		* @param bd The <code>BitmapData</code> instance to save.
		* @param path The path to save the image to.
		* @param transparent Specifies if the image has transparency or not.
		* @return An <code>int</code> represented by values of the <code>ImageSaverCodes</code>
		* @see ImageSaverCodes
		*
		**/
		public function saveImage( bd:BitmapData, path:String, transparent:Boolean = false ):int
		{
			init();
			return( __extension.call( "save", bd, path, transparent ) as int );
		}
		
		
	}
}
