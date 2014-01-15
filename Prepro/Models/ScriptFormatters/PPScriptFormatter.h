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
- (NSString *)transformInput:(NSString *)input;
- (Class)formatterForNextLine;

@end
