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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class InputPopup extends Sprite
	{
		protected var txtInput:TextField;
		protected var btnOK:CustomSimpleButton;
		protected var btnCancel:CustomSimpleButton;
		
		public function InputPopup()
		{
			this.graphics.lineStyle(1,0);
			this.graphics.beginFill(0xababab,1);
			this.graphics.drawRect(100, 300, 400, 210);
			this.graphics.endFill();
			
			txtInput = Util.getInstance().createInputField(250, 40, 170, 350);
			
			btnOK = new CustomSimpleButton("OK", 100, 40, 170, 450);
			btnCancel =  new CustomSimpleButton("Cancel", 100, 40, 320, 450);
			
			btnOK.addEventListener(MouseEvent.MOUSE_DOWN, btnOKClicked);
			btnCancel.addEventListener(MouseEvent.MOUSE_DOWN, btnCancelClicked);
			
			addChild(txtInput);
			addChild(btnOK);
			addChild(btnCancel);
			
			visible = false;
		}
		
		public function show(txtValue:String):void 
		{
			txtInput.text = txtValue;
			txtInput.setTextFormat(Util.getInstance().getTextFormat());
			visible = true;
		}
		
		public function hide():void 
		{
			visible = false;
		}
		
		protected function btnOKClicked(event:Event):void 
		{
			
		} 
		
		protected function btnCancelClicked(event:Event):void 
		{
			hide();
		} 
	}
}