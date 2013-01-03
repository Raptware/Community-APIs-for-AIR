Geocoding ANE

========================================================================
Sample Description.

This is the ActionScript portion of the AIR Native Extension.
By using conditional compilation, the project supplies the code for the device platforms as well as a default implementation for when testing locally on your computer.
Because of this you must add the following compiler argument to your project or launch configuration. 
 -define+=CONFIG::ANE,true

When set to true code will be built for the device platforms, and when set to false the default implementation is used.

You will learn:
 - How to create a simple AIR Native Extension.
 - How to use conditional compilation

========================================================================
Requirements:

BlackBerry 10 SDK for Adobe AIR

========================================================================
Running the example:

The project files in this folder are for FDT 5.5. http://fdt.powerflasher.com/
In FDT select File > Import and select the root folder.