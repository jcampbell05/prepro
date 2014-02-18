//
//  PPScriptParentheticalSection.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptParentheticalSection.h"
#import "PPScriptCenteredTableViewCell.h"

@implementation PPScriptParentheticalSection

- (Class)cellClass {
    return [PPScriptCenteredTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    cell.textLabel.text = [NSString stringWithFormat:@"(%@)", self.text];
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = [NSString stringWithFormat:@"(%@)", self.text];
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Parenthetical";
}

//Move this regex stuff into own class ? or even put place for regex constants ?
- (void)processElementText:(NSString *)text {
    
    NSError  *error  = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\((.+)\\)"
                                  options:0
                                  error:&error];
    
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, [text length])];
    
    if (matches.count > 0) {
        
        NSTextCheckingResult * match = matches[0];
        
        NSRange textRange = [match rangeAtIndex: 1];

        self.text = [text substringWithRange: textRange];
        
    } else {
        
        self.text = text;
    }
    
}

@end
