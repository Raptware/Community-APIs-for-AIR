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
	import com.wallwizz.scoreloop.Score;
	import com.wallwizz.scoreloop.ScoresController;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class ListScoresPage extends Page
	{
		private var txtWelcome:TextField;
		private var txtInfo:TextField;
		
		private var btnPrevious:CustomSimpleButton;
		private var btnNext:CustomSimpleButton;
		private var btnLocateMe:CustomSimpleButton;
		private var btnBack:CustomSimpleButton;
		
		private var arrScores:Array;
		private var rank:int;

		public function ListScoresPage()
		{
			super();

			initUI();
			
			// Add event listeners for scoreloop score requests
			ScoreloopController.getInstance().client.scoresController.addEventListener(NetworkEvent.SUCCESS, scoresRequestSuccess);
			ScoreloopController.getInstance().client.scoresController.addEventListener(NetworkEvent.ERROR, scoresRequestError);
		}
				
		private function initUI():void 
		{
			// Create text fields
			txtWelcome = Util.getInstance().createTextField(100, 50, 20, 50);
			txtWelcome.text = "High Scores";
			txtWelcome.setTextFormat(Util.getInstance().getHeaderTextFormat());
			
			txtInfo = Util.getInstance().createTextField(100, 50, 20, 100);
			txtInfo.text = "";
			txtInfo.setTextFormat(Util.getInstance().getTextFormat());
			
			// Create buttons
			btnPrevious = new CustomSimpleButton("Previous", 130, 40, 20, 700);
			btnNext = new CustomSimpleButton("Next", 120, 40, 170, 700);
			btnLocateMe = new CustomSimpleButton("Locate Me", 130, 40, 320, 700);
			btnBack = new CustomSimpleButton("Back", 100, 40, 20, 900);
			
			// Add all created elements to the page
			addChild(txtWelcome);
			addChild(txtInfo);
			addChild(btnPrevious);
			addChild(btnNext);
			addChild(btnLocateMe);
			addChild(btnBack);
			
			// Add event listeners for buttons
			btnPrevious.addEventListener(MouseEvent.MOUSE_DOWN, btnPreviousClicked);
			btnNext.addEventListener(MouseEvent.MOUSE_DOWN, btnNextClicked);
			btnLocateMe.addEventListener(MouseEvent.MOUSE_DOWN, btnLocateMeClicked);
			btnBack.addEventListener(MouseEvent.MOUSE_DOWN, btnBackClicked);
			
			// Create high score list
			arrScores = new Array;
			for (var i:int = 0; i < 10; i++) 
			{
				var scoreTextField:TextField = Util.getInstance().createTextField(400, 40, 20, 150 + (i*50)); 
				addChild(scoreTextField);
				arrScores.push(scoreTextField);
			}
			
			txtInfo.text = "Getting high scores...";
			txtInfo.setTextFormat(Util.getInstance().getTextFormat());
		}
		
		override public function init():void 
		{
			visible = true;
			rank = 1;
			loadHighScores(rank, 10);
		}
		
		private function loadHighScores(rank:int, lenght:int):void 
		{
			clearHighScoreList();
			txtInfo.text = "Getting high scores...";
			txtInfo.setTextFormat(Util.getInstance().getTextFormat());
			
			// Use ScoresController.SC_SCORE_SEARCH_LIST_GLOBAL for global scores
			// Use ScoresController.SC_SCORE_SEARCH_LIST_USER_COUNTR for users from same country
			ScoreloopController.getInstance().client.scoresController.searchList = ScoresController.SC_SCORE_SEARCH_LIST_GLOBAL;
			
			ScoreloopController.getInstance().client.scoresController.mode = Constants.SCORELOOP_STANDART_MODE;
			
			// Load high scores
			ScoreloopController.getInstance().client.scoresController.loadScoresAtRank(rank, lenght);
		}
		
		private function clearHighScoreList():void {
			for (var i:int = 0; i < 10; i++) {
				(arrScores[i] as TextField).text = "  ";
			}
		}
		
		private function scoresRequestSuccess(event:Event):void
		{
			txtInfo.text = "";

			var scores:Array = ScoreloopController.getInstance().client.scoresController.getScores();  
			
			for(var i:int=0; i < scores.length;i++)
			{
				var user:String = (scores[i] as Score).user.login;
				var result:Number = (scores[i] as Score).result;
				
				(arrScores[i] as TextField).text = user + "  "  + String(result);
				(arrScores[i] as TextField).setTextFormat(Util.getInstance().getTextFormat());
			}
		}
		
		private function scoresRequestError(event:Event):void
		{
			txtInfo.text = "Could not load high scores";
			txtInfo.setTextFormat(Util.getInstance().getTextFormat());
		}
		
		private function btnPreviousClicked(event:Event):void {
			if (rank > 10) {
				rank = rank - 10;
			} 
			
			loadHighScores(rank, rank + 10);
		}
		
		private function btnNextClicked(event:Event):void 
		{
			rank = rank + 10;
			loadHighScores(rank, rank + 10);
		}
		
		private function btnLocateMeClicked(event:Event):void 
		{
			clearHighScoreList();
			txtInfo.text = "Locating...";
			txtInfo.setTextFormat(Util.getInstance().getTextFormat());
			
			ScoreloopController.getInstance().client.scoresController.searchList = ScoresController.SC_SCORE_SEARCH_LIST_GLOBAL;
			ScoreloopController.getInstance().client.scoresController.mode = Constants.SCORELOOP_STANDART_MODE;
			ScoreloopController.getInstance().client.scoresController.loadScoresAroundUser(10);
		}
		
		private function btnBackClicked(event:Event):void 
		{
			PageNavigator.getInstance().runPage(WelcomePage);
		}
	}
}