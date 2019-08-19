<img src="https://jari.lol/ZPuuGrnTBA.png" align="right">

# XcodeRPC
Xcode Discord Integration.

## Displays active:

- File opened (& time since opened)
- File icon (over 120 file types supported)
- Workspace
- Scheme

## Download

### DMG

Get the [latest .DMG here.](https://github.com/jariz/XcodeRPC/releases/latest)

### brew cask

Coming soon once app goes stable.

## Installation 

- Drag the app into your Applications folder. (this is required, it will not function otherwise)
- Go to System Preferences > Extensions
- Click 'xcode editor' in the list that shows up.
- Check the box next to 'XDiscord Extension'
- Launch Xcode, and rich presence should start showing up in your Discord client.  
   XDiscord can now be configured by going to Editor > XDiscord > Preferences from Xcode itself.

## Development

### Technical overview

- 'XDiscord' is the main app, it is un-sandboxed because it has to read from the temporary system directory (which seems to be impossible from the sandbox, [read more about this here](https://github.com/Azoy/SwordRPC/issues/1)).  
  Additionally, you can only give temporary [AE](https://developer.apple.com/documentation/coreservices/apple_events) exceptions to sandboxed applications, essentially meaning XDiscord would basically prompt you every time you opened Xcode, which is - frankly - insane.  
  I can rant on and on about how awful the sandbox is, but this is pretty much the tldr explanation of why XDiscord is not in the app store.
- XDiscord uses AppleEvents (leveraging the [ScriptingBridge framework](https://developer.apple.com/documentation/scriptingbridge)) to read the Xcode state in 5 second intervals.
- XDiscord uses [SwordRPC](https://github.com/Azoy/SwordRPC) for rich presence publishing.
- 'XDiscord Extension' is a very small extension that doesn't do a whole lot besides launching XDiscord (the app) and additionally, signaling it to show it's preferences.  
  It is sandboxed for no other reason besides that apple seems to require extensions to be sandboxed.
  > To communicate between extension and app, we're not using any fancy interprocess communication. Just good old url schemes (with some mild hardening to prevent driveby attacks).  
  > XPC is overly complicated and a bit overkill in this case.
- XDiscord will check the [defaults](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Introduction/Introduction.html) to see if it's extension has ever written a value there, if not, it will show an alert instructing you on how to enable the extension.  
- XDiscord (the app) will shut down if it can't detect a running instance of Xcode.
  > If you have enabled XDiscord in the past, but have now decided to disable it, joke's on you! We won't show an alert in that usecase and the app will just quit.

### AssetRenderer

Icons can be generated with the `AssetRenderer` CLI tool included in this repo.  
This tool creates 512x512 icons for each file type that XCode can open, it's filenames being a hashed version of the [UTI's](https://en.wikipedia.org/wiki/Uniform_Type_Identifier).  
Unless a major new version of XCode is released, or you wish to set up your own discord application using this code, you'll probably have no use for it.
