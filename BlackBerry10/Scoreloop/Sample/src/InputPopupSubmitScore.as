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
	import com.wallwizz.scoreloop.Context;
	import com.wallwizz.scoreloop.Score;
	
	import flash.events.Event;

	public class InputPopupSubmitScore extends InputPopup
	{
		public function InputPopupSubmitScore()
		{
			super();
		}
		
		override protected function btnOKClicked(event:Event):void
		{
			var score:Number = Number(txtInput.text);
			ScoreloopController.getInstance().client.scoreController.submitScore(new Score(Constants.SCORELOOP_STANDART_MODE, 0, score, 0, null, null));
			hide();
		} 
	}
}