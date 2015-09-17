//
//  LigatureXcodePlugin.m
//  LigatureXcodePlugin
//
//  Created by Robert Vojta on 01.09.15.
//  Copyright © 2015 Robert Vojta. All rights reserved.
//

#import "LigatureXcodePlugin.h"
#import "LPXcodeUtils.h"
@import ObjectiveC.runtime;
@import AppKit;

static LigatureXcodePlugin *ligaturePluginInstance;

static NSString *UserDefaultsLigatureAttributeValueKey = @"com.robertvojta.app.LigatureXcodePlugin.LigatureAttributeValue";

static void *UserDefaultsLigatureAttributeValueContext = &UserDefaultsLigatureAttributeValueContext;
static void *CachedLigatureAttributeValueContext = &CachedLigatureAttributeValueContext;


@interface LigatureXcodePlugin() < NSMenuDelegate >

@property(nonatomic, strong) NSBundle *bundle;
@property(nonatomic, strong) NSMenu *submenu;
@property(nonatomic, assign) NSInteger cachedLigatureAttributeValue;

@end


@implementation LigatureXcodePlugin

#pragma mark - Installation

+ (LigatureXcodePlugin *)shared {
  return ligaturePluginInstance;
}

+ (void)pluginDidLoad:(NSBundle *)plugin {
  static dispatch_once_t onceToken;
  NSString *applicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
  if ( [applicationName isEqual:@"Xcode"] ) {
    dispatch_once(&onceToken, ^{
      ligaturePluginInstance = [[self alloc] initWithBundle:plugin];
    });
  }
}

- (id)initWithBundle:(NSBundle *)bundle {
  if ( ( self = [super init] ) == nil ) {
    return nil;
  }
  
  _bundle = bundle;
  _cachedLigatureAttributeValue = 1;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didApplicationFinishLaunchingNotification:)
                                               name:NSApplicationDidFinishLaunchingNotification
                                             object:nil];
  
  return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)notification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

  [self replaceAttributesAtLongestEffectiveRangeInRageForClass:NSClassFromString(@"DVTTextStorage")];
  
  [self setupObservers];
  [self installMenuItem];
}

#pragma mark - Observers

- (void)setupObservers {
  NSUserDefaultsController *udc = [NSUserDefaultsController sharedUserDefaultsController];
  NSNumber *value = [[udc values] valueForKey:UserDefaultsLigatureAttributeValueKey];
  if ( value == nil ) {
    [[udc values] setValue:@1 forKey:UserDefaultsLigatureAttributeValueKey];
  }
  
  self.cachedLigatureAttributeValue = [[[udc values] valueForKey:UserDefaultsLigatureAttributeValueKey] integerValue];
  
  [udc addObserver:self forKeyPath:[NSString stringWithFormat:@"values.%@", UserDefaultsLigatureAttributeValueKey]
           options:NSKeyValueObservingOptionNew
           context:UserDefaultsLigatureAttributeValueContext];
  [self addObserver:self forKeyPath:@"cachedLigatureAttributeValue"
            options:NSKeyValueObservingOptionNew
            context:CachedLigatureAttributeValueContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  if ( context == UserDefaultsLigatureAttributeValueContext ) {
    NSUserDefaults *ud = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
    self.cachedLigatureAttributeValue = [ud integerForKey:UserDefaultsLigatureAttributeValueKey];
    return;
  }
  if ( context == CachedLigatureAttributeValueContext ) {
    //
    // Didn't find better way to force Xcode to redraw source text view for now. Nothing did work.
    // I mean, redraw when `attributesAtIndex:longestEffectiveRange:inRange:` is utilized.
    // See `replaceAttributesAtLongestEffectiveRangeInRageForClass:` at the end of this file.
    // Probably wrong approach, will investigate more.
    //
    // I did find where Xcode set `NSLigatureAttributeName` value to `0`. But when I tried to
    // swizzle it, it didn't work. So, there must be another place where the Xcode disables
    // it.
    //
    DVTTextStorage *textStorage = [LPXcodeUtils editorSourceTextViewTextStorage];
    [textStorage addAttribute:NSLigatureAttributeName value:@(self.cachedLigatureAttributeValue) range:NSMakeRange(0, textStorage.length)];
    return;
  }
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Menu

- (void)installMenuItem {
  NSMenuItem *editMenuItem = [LPXcodeUtils mainMenuItemWithTitle:@"Edit"];
  
  if ( editMenuItem == nil ) {
    return;
  }
  
  [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
  
  
  self.submenu = [[NSMenu alloc] init];
  self.submenu.delegate = self;
  NSMenuItem *menuItem = [self.submenu addItemWithTitle:@"Disable ligatures" action:@selector(didSelectSubmenuItem:) keyEquivalent:@""];
  [menuItem setTarget:self];
  menuItem = [self.submenu addItemWithTitle:@"Enable default ligatures" action:@selector(didSelectSubmenuItem:) keyEquivalent:@""];
  [menuItem setTarget:self];
  menuItem = [self.submenu addItemWithTitle:@"Enable all ligatures" action:@selector(didSelectSubmenuItem:) keyEquivalent:@""];
  [menuItem setTarget:self];

  NSMenuItem *ligatureItem = [[NSMenuItem alloc] initWithTitle:@"Ligature plug-in" action:nil keyEquivalent:@""];
  ligatureItem.submenu = self.submenu;
  
  [[editMenuItem submenu] addItem:ligatureItem];
}

- (void)menuWillOpen:(NSMenu *)menu {
  [menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
    item.state = (idx == self.cachedLigatureAttributeValue) ? 1 : 0;
  }];
}

- (void)didSelectSubmenuItem:(NSMenuItem *)sender {
  NSUInteger index = [self.submenu.itemArray indexOfObject:sender];
  if ( index == NSNotFound ) {
    index = 0;
  }
  NSUserDefaultsController *udc = [NSUserDefaultsController sharedUserDefaultsController];
  [[udc values] setValue:@(index) forKey:UserDefaultsLigatureAttributeValueKey];
}

//
// PragmataPro Ligatures Showcase
// Ligatures list source: http://www.fsd.it/fonts/pragmatapro/PragmataPro_Haskell_liga.png
//
// !! != !== $> *** *= */ ++ +++ += +> -- -< -<< -= -> ->> .. ... ..< /* // /= /== />
// :: := <$> <$ <* <| <*> <+> <- << <<- <<< <<= <<~ <= <=> <=< <> <|> <~ <~~ <+ |>
// s=<< ==> => =~ =>> >- >= >=> >> >>- >>= >>> ?? ?~ ?= ^= ^. ^.. ^? |= || |||
// ~= ~> ~~> ~>> .~ .= #( #_ #{ %= &% && &&& &* &+ &- &/ &=
//

- (void)replaceAttributesAtLongestEffectiveRangeInRageForClass:(Class)clazz {
  SEL selector = @selector(attributesAtIndex:longestEffectiveRange:inRange:);
  Method m = class_getInstanceMethod(clazz, selector);
  IMP oldImplementation = method_getImplementation(m);
  IMP newImplementation = imp_implementationWithBlock((NSDictionary *)^(id self, NSUInteger location, NSRangePointer longestEffectiveRange, NSRange inRange) {
    NSDictionary *attributes = ((NSDictionary * (*)(id, SEL, NSUInteger, NSRangePointer, NSRange))oldImplementation)(self, selector, location, longestEffectiveRange, inRange);
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    mutableAttributes[NSLigatureAttributeName] = @([[LigatureXcodePlugin shared] cachedLigatureAttributeValue]);
    return mutableAttributes;
  });
  method_setImplementation(m, newImplementation);
}

@end
