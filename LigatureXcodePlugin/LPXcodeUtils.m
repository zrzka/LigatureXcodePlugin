//
//  LPXcodeUtils.m
//  LigatureXcodePlugin
//
//  Created by Robert Vojta on 17.09.15.
//  Copyright © 2015 Robert Vojta. All rights reserved.
//

#import "LPXcodeUtils.h"
#import "LPXcodeHeaders.h"

@implementation LPXcodeUtils

+ (NSMenu *)mainMenu {
  return [NSApp mainMenu];
}

+ (NSMenuItem *)mainMenuItemWithTitle:(NSString *)title {
  return [[self mainMenu] itemWithTitle:title];
}

+ (NSWindow *)keyWindow {
  return [[NSApplication sharedApplication] keyWindow];
}

+ (IDEWorkspaceWindowController *)workspaceWindowController {
  NSWindowController *controller = [[self keyWindow] windowController];
  if ( [controller isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")] ) {
    return (IDEWorkspaceWindowController *)controller;
  }
  return nil;
}

+ (IDEEditorArea *)editorArea {
  return [[self workspaceWindowController] editorArea];
}

+ (IDEEditorContext *)editorContext {
  return [[self editorArea] lastActiveEditorContext];
}

+ (IDEEditor *)editor {
  return [[self editorContext] editor];
}

+ (DVTSourceTextView *)editorSourceTextView {
  id editor = [self editor];
  
  if ( [editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")] ) {
    return [((IDESourceCodeEditor *)editor) textView];
  }

  if ( [editor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")] ) {
    return [((IDESourceCodeComparisonEditor *)editor) keyTextView];
  }
  
  return nil;
}

+ (DVTTextStorage *)editorSourceTextViewTextStorage {
  NSTextView *textView = [self editorSourceTextView];
  if ( [textView.textStorage isKindOfClass:NSClassFromString(@"DVTTextStorage")] ) {
    return (DVTTextStorage *)textView.textStorage;
  }
  return nil;
}


@end
