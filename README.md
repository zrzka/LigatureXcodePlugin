Quick hack to enable ligatures in the Xcode source code editor.

## Description

It forces all `DVTTextStorage` objects to use plug-in ligature settings. Not the best solution
so far, but much better compared to the previous `NSAttributedString` modifications.

I did find where Xcode sets `NSLigatureAttributeName` value to `0`. Tried to modify it, but
it didn't work. There must be another place where it's done.

Feel free to file an [issue](https://github.com/robertvojta/LigatureXcodePlugin/issues/new) if
Xcode doesn't behave as expected.

<img width="745" alt="ligatures" src="https://cloud.githubusercontent.com/assets/1084172/9930947/961becfe-5d37-11e5-8261-3fa90cb0851f.png">

## Requirements

* OS X Yosemite or El Capitan
* Xcode 7.0, 7.1
* Font with ligatures support ([PragmataPro](http://www.fsd.it/fonts/pragmatapro.htm#.VjSznYRIi34), ...)
    * Default Xcode fonts like Menlo don't support ligatures 

## Installation

### Alcatraz

Plug-in is available via [Alcatraz](http://alcatraz.io) - The package manager for Xcode.

### Manual

* open project file,
* build,
* restart Xcode.

There's `Copy Files` - `Build Phase`, which automatically installs plugin.

## Settings

You can use `Edit` - `Ligature plug-in` menu to disable ligatures, enable default ligatures (initial value) or enable all ligatures.

<img width="655" alt="edit-ligature-plugin" src="https://cloud.githubusercontent.com/assets/1084172/9930997/0421237c-5d38-11e5-8439-8bca70700405.png">

## Uninstallation

Remove `LigatureXcodePlugin.xcplugin` from `~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins`
and restart Xcode.

## Written by

- [Robert Vojta](http://github.com/robertvojta) ([@robertvojta](https://twitter.com/robertvojta))
