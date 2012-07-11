# Contributing A BlackBerry 10 ANE

When building an API for the BlackBerry 10 SDK for Adobe AIR, you will start by creating a sub-directory within this _**PlayBookOS**_ directory.  Pick a name that suits your extension and try not to use spaces in your directory name.  It just plain makes things easier.  

As a recipe for building your API you can use the _**BPS extension**_ as a good example.  

_**[Description on how to structure your code directories should go here]**_


A _**README.md**_ file also needs to be created at the root of your directory where you can place all the information about how to use and configure your API.  The _**BPS extension**_ is a good example of what type of information to include in your README.md file.  This README.md file uses Markdown wiki formatting. 


## BlackBerry PlayBook OS ANE Tutorial

You can also find a [tutorial](http://supportforums.blackberry.com/t5/Adobe-AIR-Development/Creating-AIR-Native-Extensions-for-BB10/ta-p/1376479) on creating an ANE created by a member of the community. 


## Testing Your API

You can test your API with an existing installed WebWorks SDK for Tablet OS by following the below steps:

1. Locate your BlackBerry WebWorks SDK for Smartphone extensions directory using your File Explorer.  Default path is _**C:\Program Files\Research In Motion\BlackBerry WebWorks SDK for TabletOS\bbwp\ext**_

2. Create a new directory for your API in the _**ext**_ directory. This should be named the same as your feature id _**fancy.new.api**_

3. Copy your _**library.xml**_ file into to your new _**ext\fancy.new.api**_ directory

4. Copy your root code _**src**_ directory and your _**js**_ directory to your newly created _**ext\fancy.new.api**_ directory

5. Create a WebWorks Application using your API and create a feature element specifying the ID of your API.  &lt;feature id="fancy.new.api" /&gt;

6. Build your application using the _**bbwp.exe**_ command line and test your application on the desired simulator