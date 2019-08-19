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

### AssetRenderer

Icons can be generated with the `AssetRenderer` CLI tool included in this repo.  
This tool creates 512x512 icons for each file type that XCode can open, it's filenames being a hashed version of the [UTI's](https://en.wikipedia.org/wiki/Uniform_Type_Identifier).  
Unless a major new version of XCode is released, or you wish to set up your own discord application using this code, you'll probably have no use for it.
