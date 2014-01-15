//
//  PPScriptActionFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptActionFormatter.h"
#import "PPScriptCharacterFormatter.h"

@implementation PPScriptActionFormatter

- (NSString *)title {
    return @"Action";
}

- (NSDictionary *)attributes {
    return @{ @"type" : [self title] };
}

- (Class)formatterForNextLine {
    return [PPScriptCharacterFormatter class];
}

@end
