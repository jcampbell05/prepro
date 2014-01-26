//
//  PPScriptParentheticalFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptParentheticalFormatter.h"

@implementation PPScriptParentheticalFormatter

- (NSString *)title {
    return @"Parenthetical";
}

- (NSString *)prefixString {
    return @"(";
}

- (NSString *)postfixString {
    return @")";
}

@end
