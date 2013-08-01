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
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
	public class CustomSimpleButton extends SimpleButton 
	{
		private var upColor:uint   = 0xFFCC00;
		private var overColor:uint = 0xFFCC00;
		private var downColor:uint = 0x00CCFF;
		private var w:uint;
		private var h:uint;
		private var text:String;
		
		public function CustomSimpleButton(text:String, w:uint, h:uint, x:int, y:int) 
		{
			downState      = new ButtonDisplayState(downColor, text, w, h);
			overState      = new ButtonDisplayState(overColor, text, w, h);
			upState        = new ButtonDisplayState(upColor, text, w, h);
			hitTestState   = new ButtonDisplayState(upColor, text, w, h);
			useHandCursor  = true;
			
			this.text = text;
			this.x = x;
			this.y = y;
		}
	}
}