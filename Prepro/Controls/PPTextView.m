//
//  PPTextView.m
//  Prepro
//
//  Created by James Campbell on 28/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPTextView.h"
#import "FountainRegexes.h"

@implementation PPTextView (Private)

- (NSArray *)matchesForRegex:(NSString *)pattern {
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    
    return [regex matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
}

@end

@implementation PPTextView

- (id)init {
    if ( self = [super init] ){
        [self registerForKeyboardNotifications];
    }
    
    return self;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.frame.origin) ) {
        [self scrollRectToVisible:self.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
}

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

- (NSRange)rangeForSelectedText {
    
    UITextRange * textRange = self.selectedTextRange;
    
    UITextPosition * beginning = self.beginningOfDocument;
    UITextPosition * start = textRange.start;
    UITextPosition * end = textRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:start];
    NSInteger length = [self offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
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

- (NSString *)textForCurrentLine {
    return [self.text substringWithRange:[self rangeForCurrentLine]];
}

- (BOOL)currentLineHasPrefix:(NSString *)prefix {
    return [[self textForCurrentLine] hasPrefix: prefix];
}

- (BOOL)currentLineHasSuffix:(NSString *)suffix {
   return [[self textForCurrentLine] hasSuffix: suffix];
}

- (UITextRange *)textRangeFromRange:(NSRange)range
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    
    return [self textRangeFromPosition:start toPosition:end];
}

- (void)scrollToCaret {
    CGRect line = [self caretRectForPosition: self.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height - ( self.contentOffset.y + self.bounds.size.height - self.contentInset.bottom - self.contentInset.top );
    
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = self.contentOffset;
        
        offset.y += overflow + 7; // leave 7 pixels margin
        
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [self setContentOffset:offset];
        }];
    }
}

@end
