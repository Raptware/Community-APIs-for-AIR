# BBM AIR Native Extension

The code in this repository is responsible exposing the native library through a ActionScript interface.

The sample code for this application is Open Source under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

**Author(s)** 

* [Julian Dolce](http://www.twitter.com/jdolce)

**To contribute code to this repository you must be [signed up as an official contributor](http://blackberry.github.com/howToContribute.html).**

**Requirements:**  
* BlackBerry 10 AIR SDK 

**Building the Source:**  
The project files included with the source are for FDT 5.6. The following build instructions apply for this IDE only. Other IDEs may have slightly different setup.  
1. Select File > Import  
2. Select General > Existing Projects into Workspace  
3. Select Browse to select the project root directory and select the current folder on your computer.  
4. Press Finish  
  
2 Launch configurations should be included, bbmane default and bbmane device. You are required to build both of these in order to build the ane.  
  
**NOTE:**  
If you are using another IDE, you must ensure that the qnxui.swc from the BlackBerry 10 AIR SDK is linked into the project. There is also a compiler conditional that will is used to build the bbmane.swc and bbmanedefault.swc. The bbmane.swc should be compiled with the following conditional  _-define+=CONFIG::ANE,true_ and the bbmanedefault.swc should be compiled with  _-define+=CONFIG::ANE,false_.  