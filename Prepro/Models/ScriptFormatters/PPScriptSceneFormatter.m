//
//  PPScriptSceneFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptSceneFormatter.h"
#import "PPScriptActionFormatter.h"

@implementation PPScriptSceneFormatter

- (NSString *)title {
    return @"Scene";
}

- (NSDictionary *)attributes {
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;

    paragraphStyle.paragraphSpacing = 0.5 * font.lineHeight;
    
    return @{ @"type" : [self title], NSBackgroundColorAttributeName : [UIColor lightGrayColor], NSParagraphStyleAttributeName : paragraphStyle };
}

- (NSString *)transformInput:(NSString *)input {
    return [input uppercaseString];
}

- (Class)formatterForNextLine {
    return [PPScriptActionFormatter class];
}

@end
