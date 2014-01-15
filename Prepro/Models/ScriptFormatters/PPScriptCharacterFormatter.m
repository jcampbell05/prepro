//
//  PPScriptCharacterFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptCharacterFormatter.h"
#import "PPScriptDialogueFormatter.h"

@implementation PPScriptCharacterFormatter

- (NSString *)title {
    return @"Character";
}

- (NSDictionary *)attributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    return @{ @"type" : [self title], NSParagraphStyleAttributeName : paragraphStyle };
}

- (NSString *)transformInput:(NSString *)input {
    return [input uppercaseString];
}

- (Class)formatterForNextLine {
    return [PPScriptDialogueFormatter class];
}

@end
