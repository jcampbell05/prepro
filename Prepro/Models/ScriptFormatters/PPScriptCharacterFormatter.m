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
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacing = 0.2 * font.lineHeight;
    
    return @{ @"type" : [self title], NSParagraphStyleAttributeName : paragraphStyle };
}

- (NSString *)transformInput:(NSString *)input {
    return [input uppercaseString];
}

- (Class)formatterForNextLine {
    return [PPScriptDialogueFormatter class];
}

@end
