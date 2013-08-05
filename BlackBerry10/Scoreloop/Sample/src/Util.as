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
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Util
	{
		// Singleton object
		private static var instance:Util;
		private static var allowInstantiation:Boolean = true; // private constructor is not allowed in ecmascript standart this is a hack method to provide singleton funtionality
		
		
		public function Util()
		{
			if(!allowInstantiation)
			{
				throw new Error("Error: Instantiation failed: Use Util.getInstance() instead of new.");
			}
		}
		
		public static function getInstance() : Util
		{
			if (instance == null)
			{
				instance = new Util();
				allowInstantiation = false;
			}
			return instance;
		}
				
		public function createTextField(width:int, height:int, x:int, y:int):TextField 
		{
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = x;
			txt.y = y;
			txt.width = width;
			txt.height = height;			
			return txt;
		}
		
		public function createInputField(width:int, height:int, x:int, y:int):TextField 
		{
			var inputField:TextField = new TextField();
			inputField.border = true;
			inputField.background = true;
			inputField.type = TextFieldType.INPUT;
			inputField.autoSize = TextFieldAutoSize.NONE;
			inputField.width = width;
			inputField.height = height;
			inputField.x = x;
			inputField.y = y;
			
			inputField.setTextFormat(Util.getInstance().getTextFormat());
		
			return inputField;
		}
		
		public function getTextFormat():TextFormat 
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.font = "Verdana";
			tf.size = 24;
			tf.align = "center";
			
			return tf;
		}
		
		public function getHeaderTextFormat():TextFormat 
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x000000;
			tf.font = "Verdana";
			tf.size = 36;
			tf.align = "center";
			tf.bold = true;
			
			return tf;
		}
		
		public function getErrorTextFormat():TextFormat 
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFF0000;
			tf.font = "Verdana";
			tf.size = 24;
			tf.align = "center";
			
			return tf;
		}
	}
}