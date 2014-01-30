//
//  PPDocumentViewController.h
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Switch Document Screens to use this

#import <UIKit/UIKit.h>

@interface PPDocumentViewController : UIViewController<UITextFieldDelegate> {
    UITextField * _titleTextField;
    
    UITapGestureRecognizer *_singleTapRecognizer;
    UITapGestureRecognizer *_titleDoubleTapGestureRecognizer;
}

@property (assign, nonatomic) BOOL isTitleDoubleTapToEditGestureEnabled;

- (void)startEditingTitle;
- (void)endEditingTitle;
- (void)save;

@end
