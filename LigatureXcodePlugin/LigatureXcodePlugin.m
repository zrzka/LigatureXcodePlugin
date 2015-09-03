//
//  LigatureXcodePlugin.m
//  LigatureXcodePlugin
//
//  Created by Robert Vojta on 01.09.15.
//  Copyright © 2015 Robert Vojta. All rights reserved.
//

#import "LigatureXcodePlugin.h"
@import ObjectiveC.runtime;
@import AppKit;

@implementation LigatureXcodePlugin

//
// PragmataPro Ligatures Showcase
// Ligatures list source: http://www.fsd.it/fonts/pragmatapro/PragmataPro_Haskell_liga.png
//
// !! != !== $> *** *= */ ++ +++ += +> -- -< -<< -= -> ->> .. ... ..< /* // /= /== />
// :: := <$> <$ <* <| <*> <+> <- << <<- <<< <<= <<~ <= <=> <=< <> <|> <~ <~~ <+ |>
// s=<< ==> => =~ =>> >- >= >=> >> >>- >>= >>> ?? ?~ ?= ^= ^. ^.. ^? |= || |||
// ~= ~> ~~> ~>> .~ .= #( #_ #{ %= &% && &&& &* &+ &- &/ &=
//

+ (void)replaceAttributesAtLongestEffectiveRangeInRageForClass:(Class)clazz {
  SEL selector = @selector(attributesAtIndex:longestEffectiveRange:inRange:);
  Method m = class_getInstanceMethod(clazz, selector);
  IMP oldImplementation = method_getImplementation(m);
  IMP newImplementation = imp_implementationWithBlock((NSDictionary *)^(id self, NSUInteger location, NSRangePointer longestEffectiveRange, NSRange inRange) {
    NSDictionary *attributes = ((NSDictionary * (*)(id, SEL, NSUInteger, NSRangePointer, NSRange))oldImplementation)(self, selector, location, longestEffectiveRange, inRange);
    NSMutableDictionary *ma = [attributes mutableCopy];
    [ma setObject:@1 forKey:NSLigatureAttributeName];
    return ma;
  });
  method_setImplementation(m, newImplementation);
}

+ (void)load {
  [self replaceAttributesAtLongestEffectiveRangeInRageForClass:[NSAttributedString class]];
}

@end
