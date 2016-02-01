Mediabrix Unity Support- Realese Notes
=======

iOS
================

1.5-800
* 1.5 is a major update, please please advize the SDK README.md and release notes. More documentatoin is available on http://knowledge.mediabrix.com/#ios-setup.

1.4-515
* This version has updates for the new mediabrix-ios-sdk version 1.4-515. Please read the releaseNotes.md file in the iOS root folder.
* This version, the automatically generated unity xcode project will additinally have version required that use include the CoreTelephony.Framework.

Android
================
1.4-515
1.5-815
* bug fixes to setting and clearing mbrixVars
* Includes the new mediabrix 1.5 APi with manifest engine for faster ad fetches and high server side concurrency.
* changed name of callback from onAdLoadFailed to onAdFailed for more consistency with core API.
* removed context passing from c# layer to android java layer, since it was possible to access the context in the android layer only
* fixed a number of concurrency issues by dispatching all calls on android thread internally.
* Enhanced test UI for mbrixVars setting and increased the size of font used for readabililty.
1.5.6
* built using version 4.3.4 of unity.
* added target name when receiving a reward

