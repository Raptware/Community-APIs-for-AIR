# BBM AIR Native Extension

The BBM AIR Native Extension allows AIR developers to interact with the BBM Social Platform native APIs. Included in this repository is the ActionScript and C source code for the ANE. The bbm.ane file is the compiled version of the source. See the README files in the as3 and native folders for more information about building the ActionScript and C source code.  
    
Documentation can be found on the wiki pages.
  
The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

**Author(s)** 

* [Julian Dolce](http://www.twitter.com/jdolce)

**To contribute code to this repository you must be [signed up as an official contributor](http://blackberry.github.com/howToContribute.html).**

**Requirements:**  
* BlackBerry 10 SDK for Adobe AIR  
* BlackBerry 10 NDK  

**Building the bbm.ane:**  
Once the source in the as3 and native folders has been compiled, you can run the buildane.sh file to build the bbm.ane. In the buildane.sh there is a AIR_SDK_PATH property that needs to be changed to point to your AIR SDK bin folder.