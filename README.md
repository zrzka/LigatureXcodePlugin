Quick hack to enable ligatures in the Xcode source code editor.

## Description

It forces all `DVTTextStorage` objects to use plug-in ligature settings. Not the best solution
so far, but much better compared to the previous `NSAttributedString` modifications.

I did find where Xcode sets `NSLigatureAttributeName` value to `0`. Tried to modify it, but
it didn't work. There must be another place where it's done.

Feel free to file an [issue](https://github.com/robertvojta/LigatureXcodePlugin/issues/new) if
Xcode doesn't behave as expected.

## Requirements

- OS X Yosemite or El Capitan
- Xcode 7.0

## Installation

* open project file,
* build,
* restart Xcode.

There's `Copy Files` - `Build Phase`, which automatically installs plugin.

## Settings

You can use `Edit` - `Ligature plug-in` menu to disable ligatures, enable
default ligatures (initial) or enable all ligatures.

## Uninstallation

Remove `LigatureXcodePlugin.xcplugin` from `~/Application Support/Developer/Shared/Xcode/Plug-ins`
and restart Xcode.

## Written by

- [Robert Vojta](http://github.com/robertvojta) ([@robertvojta](https://twitter.com/robertvojta))
