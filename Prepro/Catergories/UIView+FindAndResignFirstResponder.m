//
//  UIView+FindAndResignFirstResponder.m
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

- (id)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findFirstResponder])
            return subView;
    }
    return nil;
}

@end
