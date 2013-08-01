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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ButtonDisplayState extends Sprite 
	{
		private var bgColor:uint;
		private var w:uint;
		private var h:uint;
		private var buttonText:TextField; 
		
		public function ButtonDisplayState(bgColor:uint, text:String, w:uint, h:uint) 
		{
			this.bgColor = bgColor;
			this.w = w;
			this.h = h;
			draw(text);
		}
		
		private function draw(text:String):void 
		{
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			buttonText = new TextField;
			buttonText.text = text;
			buttonText.width = w;
			buttonText.height = h;
			buttonText.y = h/8;
			buttonText.setTextFormat(Util.getInstance().getTextFormat());
			addChild(buttonText);
		}
	}
}
