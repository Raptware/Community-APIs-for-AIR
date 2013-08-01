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
	public class PageNavigator
	{
		// Singleton object
		private static var instance:PageNavigator;
		private static var allowInstantiation:Boolean = true; // private constructor is not allowed in ecmascript standart this is a hack method to provide singleton funtionality
		
		// Class Variables
		private var pageList:Array = new Array();
		private var activePage:Page = null;
		private var activePageClass:Class = null;
		
		// Class Methods
		public function PageNavigator()
		{
			if(!allowInstantiation)
			{
				throw new Error("Error: Instantiation failed: Use PageNavigator.getInstance() instead of new.");
			}
		}
		
		public static function getInstance() : PageNavigator 
		{
			if (instance == null) 
			{
				instance = new PageNavigator();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function register(page:Page) : void 
		{
			pageList.push(page);
		}
		
		public function runPage(pageClass:Class) : void 
		{
			if(activePage) {
				activePageClass = pageClass;
				activePage.shutdown();
			}
			else {
				for each (var page:Page in pageList) 
				{
					if(page is pageClass)
					{
						activePage = page;
						activePage.init();
						return;
					}
				}
			}
		}
		
		public function shutdownCompleted():void 
		{	
			if (activePageClass != null) {
				for each (var page:Page in pageList) 
				{
					if(page is activePageClass)
					{
						activePage = page;
						activePage.init();
						return;
					}
				}
			}
			
		}
	}
}