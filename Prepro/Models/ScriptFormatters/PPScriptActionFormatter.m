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
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    paragraphStyle.paragraphSpacing = 1 * font.lineHeight;
    
    return @{ @"type" : [self title], NSParagraphStyleAttributeName : paragraphStyle };
}

- (Class)formatterForNextLine {
    return [PPScriptCharacterFormatter class];
}

@end
