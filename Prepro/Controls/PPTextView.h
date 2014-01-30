//
//  PPTextView.h
//  Prepro
//
//  Created by James Campbell on 28/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTextView : UITextView

- (int)locationOfRegexMatchBeforeCaret:(NSString *)pattern;
- (int)locationOfRegexMatchAfterCaret:(NSString *)pattern;

- (NSRange)rangeForSelectedText;
- (NSRange)rangeForCurrentLine;
- (UITextRange *)textRangeFromRange:(NSRange)range;

@end
