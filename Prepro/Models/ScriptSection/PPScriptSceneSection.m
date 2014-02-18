//
//  PPScriptSceneSection.m
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: A bit of duplication here

#import "PPScriptSceneSection.h"
#import "PPScriptSceneTableViewCell.h"

@implementation PPScriptSceneSection

- (NSString *)cellIdentifier {
    return @"scene";
}

- (Class)cellClass {
    return [PPScriptSceneTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    
    //TODO: Create Prepro Macro to handle some of this
    cell.textLabel.text = [[NSString stringWithFormat:@"%@. %@", (self.type) ? self.type : @"", self.title] uppercaseString];
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = [[NSString stringWithFormat:@"%@. %@", (self.type) ? self.type : @"", self.title] uppercaseString];
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Scene Heading";
}

//Move this regex stuff into own class ? or even put place for regex constants ?
- (void)processElementText:(NSString *)text {
    
    NSError  *error  = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"([A-Z/]+)\\. (.+)"
                                  options:0
                                  error:&error];
    
    NSArray *matches = [regex matchesInString:text
                                               options:0
                                                 range:NSMakeRange(0, [text length])];
    
    if (matches.count > 0) {
    
        NSTextCheckingResult * match = matches[0];
        
        NSRange typeRange = [match rangeAtIndex: 1];
        NSRange titleRange = [match rangeAtIndex: 2];
        
        self.type = [text substringWithRange: typeRange];
        self.title = [text substringWithRange: titleRange];
        
    } else {
        
        self.title = text;
    }
    
}

@end
