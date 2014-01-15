//
//  PPScriptSceneFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptSceneFormatter.h"

@implementation PPScriptSceneFormatter

- (NSString *)title {
    return @"Scene";
}

- (NSDictionary *)attributes {
    return @{ @"type" : [self title], NSBackgroundColorAttributeName : [UIColor lightGrayColor] };
}

- (NSString *)transformInput:(NSString *)input {
    return [input uppercaseString];
}

@end
