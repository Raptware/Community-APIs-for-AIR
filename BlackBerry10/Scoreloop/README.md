Scoreloop ANE

========================================================================
ANE Description

Scoreloop ANE enables you to add Scoreloop support to your AIR game
using Actionscript 3. Using this native extension, you can; 

 - Authenticate your gamers
 - Submit scores to Scoreloop Servers (Supports multiple game modes, multiple levels etc.)
 - Access daily/global/location based leader boards
 - Access ranking api for game and queries


========================================================================
Requirements:

Flash Builder 
QNX Momentix
BlackBerry 10 SDK for Adobe AIR
BlackBerry 10 NDK

========================================================================
ANE Usage

You can use the prebuilt scoreloopane_bb10.ane or scoreloopane_pb.ane
without compiling the C project and the ANE Adobe Air Project. 

You can find AS3DOC of ANE API in "ANE/Doc" folder.

You can check the Sample directory for a sample Scoreloop
implementation. This sample implementation covers nearly all the API
available on ANE.

========================================================================
Contributing to code and compiling the ANE

You will need to recompile the ANE if you decide to contribute to the
code. 

ANE project is created with Flash Builder. You can open the project in
Flash Builder and start developing AS3 API for your ANE. You will use
the SWC that you create here in second step.

Second step will be native development and AS3 ANE integration. You need
to open the Native project in QNX Momentix and implement the interfaces
that you have defined in AS3. You can check the other methods that are
implemented as reference. 

Scoreloop C API has differences between BB10 and Playbook, Scoreloop ANE
C project can be compiled either for BB10 or Playbook. To compile it for
BB10 you need to define BB10 as a compilation parameter. You can use QNX
Momentix project settings to set the BB10 value to true. 

You should point your SWC created in first step to create the final ANE


