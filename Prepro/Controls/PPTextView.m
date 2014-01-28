//
//  PPTextView.m
//  Prepro
//
//  Created by James Campbell on 28/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPTextView.h"

@implementation PPTextView (Private)

- (NSArray *)matchesForRegex:(NSString *)pattern {
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    
    return [regex matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
}

@end

@implementation PPTextView

- (int)locationOfRegexMatchBeforeCaret:(NSString *)pattern {
    
     __block int result = -1;
    
    int caretPosition = self.selectedRange.location;
    NSArray * newLineLocations = [self matchesForRegex:pattern];
    
    [newLineLocations enumerateObjectsUsingBlock:^(NSTextCheckingResult * textResult, NSUInteger idx, BOOL *stop) {
        
        if (textResult.range.location <= caretPosition) {
            result = textResult.range.location;
            
            *stop = YES;
        }
    }];
    
    return result;
}

- (int)locationOfRegexMatchAfterCaret:(NSString *)pattern {
    
     __block int result = -1;
    
    int caretPosition = self.selectedRange.location;
    NSArray * newLineLocations = [self matchesForRegex:pattern];
    
    [newLineLocations enumerateObjectsUsingBlock:^(NSTextCheckingResult * textResult, NSUInteger idx, BOOL *stop) {
        
        if (textResult.range.location >= caretPosition) {
            result = textResult.range.location;
            
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSRange)rangeForCurrentLine {
    
    int locationOfNewLineBeforeCaret = [self locationOfRegexMatchBeforeCaret:@"\n"];
    int locationOfNewLineAfterCaret = [self locationOfRegexMatchAfterCaret:@"\n"];
    
    if (locationOfNewLineBeforeCaret == -1) {
        locationOfNewLineBeforeCaret = 0;
    }
    
    if (locationOfNewLineAfterCaret == -1) {
        locationOfNewLineAfterCaret = self.text.length;
    }
    
    NSRange result;
    result.location = locationOfNewLineBeforeCaret;
    result.length = locationOfNewLineAfterCaret - locationOfNewLineBeforeCaret;
    
    return result;
}

@end
