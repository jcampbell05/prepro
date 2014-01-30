//
//  PPScriptFormatter.h
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPScriptFormatter : NSObject

- (NSString *)title;
- (NSDictionary *)attributes;

- (UITextAutocapitalizationType)autocapitalizationType;
- (NSString *)transformInput:(NSString *)input;

- (NSString *)prefixString;
- (NSString *)postfixString;

- (Class)formatterForNextLine; //TODO: Allow user to pick how this works

@end
