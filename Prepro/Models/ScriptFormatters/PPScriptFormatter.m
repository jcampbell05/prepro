//
//  PPScriptFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptFormatter.h"

@implementation PPScriptFormatter

- (NSString *)title {
    return @"Title";
}

- (NSDictionary *)attributes {
    return @{};
}

- (NSString *)transformInput:(NSString *)input {
    return input;
}

@end
