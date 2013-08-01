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

package com.wallwizz.scoreloop
{
	/**
	 * Models the score achieved by a particular user in a particular game session.
	 * Instances of \ref SC_Score must, at minimum, contain a result, which
	 * is typically the main numerical outcome achieved by a user of
	 * the game. 
	 * - A score can be a simple single-digit score or a score that is based on time.
	 * - A score can also be more complex with multiple criteria, such as the number of hits made,
	 *   the average speed, or the maximum speed that can be modeled by using:
	 *    - A minor or secondary result
	 *    - A level that indicates the game stage at which the score was achieved
	 *    - A mode that indicates the gameplay setting at which the score was achieved
	 * - A score is submitted to the server, and sorting of the scores affects who wins a challenge
	 *   or who ranks better in the leaderboards.
	 * - Scores can be sorted in ascending or descending order.
	 *
	 * The result, minor result, and level are used for score comparison purposes.
	 * You can configure the comparison schema at
	 * <a href="https://developer.scoreloop.com">https://developer.scoreloop.com
	 * </a>.
	 *
	 *
	 * Modes are important as Scoreloop generates separate leaderboards for each mode defined for a game.
	 *
	 * Scores are managed by two data controllers:
	 * - An ScoreController, which manages single instances of Score
	 * - An ScoresController, which manages lists of Score
	 *
	 * Instances of Score can also contain information about score rank, which is the
	 * position of the score on a Scoreloop leaderboard. However, the rank of a score
	 * will generally only have a meaningful value when it is retrieved from the
	 * server using an ScoresController.
	 *
	 * @author caneraltinbasak
	 * 
	 */
	public class Score
	{
		private var _mode:int;
		private var _level:int;
		private var _result:int;
		private var _minorResult:int;
		private var _user:User;
		private var _context:Array;
		/**
		 * Instances of \ref SC_Score model the score achieved by a particular
		 * user in a particular game session. 
		 * @param mode Mode of the Score
		 * @param level The level that the current score was achieved at
		 * @param result The result property for the score
		 * @param minorResult The minor result property for the score
		 * @param user The user who obtained and submitted the score(should be null when creating a score for submitting)
		 * @param context context associated with score
		 * 
		 */
		public function Score(mode:int,level:int,result:Number,minorResult:Number,user:User = null, context:Array = null)
		{
			_mode=mode;
			_level=level;
			_result=result;
			_minorResult=result;
			_user = user;
			_context = context;
		}

		/**
		 * The game mode of the Score. 
		 * 
		 */
		public function get mode():int
		{
			return _mode;
		}

		/**
		 * @private 
		 *  
		 */
		public function set mode(value:int):void
		{
			_mode = value;
		}

		/**
		 * The level of the score. 
		 * 
		 */
		public function get level():int
		{
			return _level;
		}

		/** 
		 * @private
		 * 
		 */
		public function set level(value:int):void
		{
			_level = value;
		}

		/**
		 *  Result of the Score.
		 * 
		 */
		public function get result():int
		{
			return _result;
		}

		/**
		 * @private 
		 * 
		 */
		public function set result(value:int):void
		{
			_result = value;
		}

		/**
		 * Minor Result of the Score. 
		 * 
		 */
		public function get minorResult():int
		{
			return _minorResult;
		}

		/**
		 * @private 
		 * 
		 */
		public function set minorResult(value:int):void
		{
			_minorResult = value;
		}
		/**
		 * The User that has associated with this score. 
		 * 
		 */
		public function get user():User
		{
			return _user
		}

		/**
		 * Context value array of the score. 
		 * 
		 */
		public function get context():Array
		{
			return _context;
		}

		/**
		 * @private 
		 * 
		 */
		public function set context(value:Array):void
		{
			_context = value;
		}


		// TODO: Context requires ptr access. It is not implemented due to ANE limitation

	}
}