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
	import com.wallwizz.scoreloop.NetworkEvent;
	import com.wallwizz.scoreloop.ScoreController;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WelcomePage extends Page
	{
		private var txtWelcome:TextField;
		private var txtUsername:TextField;
		private var txtError:TextField;
		
		private var btnUsername:CustomSimpleButton;
		private var btnListScores:CustomSimpleButton;
		private var btnSubmitScore:CustomSimpleButton;
		
		private var inputPopupUsername:InputPopupUsername;
		private var inputPopupSubmitScore:InputPopupSubmitScore;
		
		public function WelcomePage()
		{
			super();
			
			initUI();
			
			// Add event listeners for scoreloop user requests
			ScoreloopController.getInstance().client.userController.addEventListener(NetworkEvent.SUCCESS, userRequestSuccess);
			ScoreloopController.getInstance().client.userController.addEventListener(NetworkEvent.ERROR, userRequestError);
			
			// Request current user
			ScoreloopController.getInstance().client.userController.requestCurrentUser();
		}
		
		private function initUI():void
		{
			// Create text fields
			txtWelcome = Util.getInstance().createTextField(100, 50, 20, 50);
			txtWelcome.text = "Welcome Page";
			txtWelcome.setTextFormat(Util.getInstance().getHeaderTextFormat());
			
			txtUsername = Util.getInstance().createTextField(100, 50, 20, 150);
			txtUsername.text = "Getting username...";
			txtUsername.setTextFormat(Util.getInstance().getTextFormat());
			
			txtError = Util.getInstance().createTextField(100, 50, 20, 400);
			txtError.text = "";
			
			// Create buttons
			btnUsername = new CustomSimpleButton("Change Username", 230, 40, 350, 150);
			btnListScores = new CustomSimpleButton("List Scores", 180, 40, 20, 250);
			btnSubmitScore = new CustomSimpleButton("Submit Score", 180, 40, 20, 310);
		
			// Create popups to get input from the user
			inputPopupUsername = new InputPopupUsername;
			inputPopupSubmitScore = new InputPopupSubmitScore;
			
			// Add all created elements to the page
			addChild(txtWelcome);
			addChild(txtUsername);
			addChild(txtError);
			addChild(btnUsername);
			addChild(btnListScores);
			addChild(btnSubmitScore);
			addChild(inputPopupUsername);
			addChild(inputPopupSubmitScore);
			
			// Add event listeners for buttons
			btnUsername.addEventListener(MouseEvent.MOUSE_DOWN, btnUserNameClicked);
			btnListScores.addEventListener(MouseEvent.MOUSE_DOWN, btnListScoresClicked);
			btnSubmitScore.addEventListener(MouseEvent.MOUSE_DOWN, btnSubmitScoreClicked);
		}
		
		protected function userRequestError(event:NetworkEvent):void
		{
			var error:int = ScoreloopController.getInstance().client.userController.getValidationErrors();
			
			if (error == Constants.SC_USERNAME_ALREADY_TAKEN) 
			{
				trace("SC_USERNAME_ALREADY_TAKEN");
				txtError.text = "Username is already taken";
				txtError.setTextFormat(Util.getInstance().getErrorTextFormat());
			}
			else if (error == Constants.SC_USERNAME_FORMAT_INVALID) 
			{
				trace("SC_USERNAME_FORMAT_INVALID");
				txtError.text = "Username format is invalid";
				txtError.setTextFormat(Util.getInstance().getErrorTextFormat());
				
			}
			else if (error == Constants.SC_USERNAME_TOO_SHORT) 
			{
				trace("SC_USERNAME_TOO_SHORT");
				txtError.text = "Username is too short";
				txtError.setTextFormat(Util.getInstance().getErrorTextFormat());
			}
		}
		
		protected function userRequestSuccess(event:NetworkEvent):void
		{
			// Get username of the user 
			txtUsername.text = ScoreloopController.getInstance().client.userController.getUser().login;
			txtUsername.setTextFormat(Util.getInstance().getTextFormat());
			
			txtError.text = "";
		}	
		
		private function btnUserNameClicked(event:Event):void 
		{
			// Show popup to change username 
			inputPopupUsername.show(txtUsername.text);
		}
		
		private function btnListScoresClicked(event:Event):void 
		{
			// Navigate to high scores page
			PageNavigator.getInstance().runPage(ListScoresPage);
		}
		
		private function btnSubmitScoreClicked(event:Event):void
		{
			// Show popup to submit a new score for the user 
			inputPopupSubmitScore.show("1000");
		}
	}
}