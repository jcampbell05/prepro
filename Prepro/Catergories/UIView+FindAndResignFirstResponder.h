//
//  UIView+FindAndResignFirstResponder.h
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder;
- (id)findFirstResponder;
- (id)deepFindViewWithTag:(int)tag;

@end
