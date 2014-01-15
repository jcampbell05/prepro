//
//  PPScriptDialogueFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptDialogueFormatter.h"

@implementation PPScriptDialogueFormatter

- (NSString *)title {
    return @"Dialogue";
}

- (NSDictionary *)attributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    return @{ @"type" : [self title], NSParagraphStyleAttributeName : paragraphStyle };
}

@end
