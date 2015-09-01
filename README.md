Quick hack to enable ligatures in Xcode.

## Requirements

- OS X El Capitan
- Xcode 7.0

## Installation

* open project file,
* build,
* restart Xcode.

There's `Copy Files` - `Build Phase`, which automatically copies plugin to `Plug-ins` directory.

## Warning

As I wrote, it's a quick hack. It forces *all* attributed strings to use ligatures. If your Xcode
behaves weirdly, just delete it.

## Written by

- [Robert Vojta](http://github.com/robertvojta) ([@robertvojta](https://twitter.com/robertvojta))

## License

Do whatever you do want to do with this plugin :-)

