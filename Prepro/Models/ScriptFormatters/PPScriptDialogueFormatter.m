//
//  PPScriptDialogueFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptDialogueFormatter.h"
#import "PPScriptCharacterFormatter.h"

@implementation PPScriptDialogueFormatter

- (NSString *)title {
    return @"Dialogue";
}

- (NSDictionary *)attributes {
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacing = 0.5 * font.lineHeight;
    
    return @{ @"type" : [self title], NSParagraphStyleAttributeName : paragraphStyle };
}

- (Class)formatterForNextLine {
    return [PPScriptCharacterFormatter class];
}

@end
