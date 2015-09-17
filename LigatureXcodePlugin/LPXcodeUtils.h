//
//  LPXcodeUtils.h
//  LigatureXcodePlugin
//
//  Created by Robert Vojta on 17.09.15.
//  Copyright © 2015 Robert Vojta. All rights reserved.
//

@import AppKit;
#import "LPXcodeHeaders.h"

@interface LPXcodeUtils : NSObject

+ (NSMenu *)mainMenu;
+ (NSMenuItem *)mainMenuItemWithTitle:(NSString *)title;
+ (DVTSourceTextView *)editorSourceTextView;
+ (DVTTextStorage *)editorSourceTextViewTextStorage;

@end
