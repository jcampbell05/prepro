//
//  PPDocumentViewController.h
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Switch Document Screens to use this - Find out when you should use iVars vs Private Properties

#import <UIKit/UIKit.h>
#import "PPDocumentView.h"

const NSString * exposeNotification;
const NSString * documentListNotification;

@interface PPDocumentViewController : UIViewController<UITextFieldDelegate> {
    UITextField * _titleTextField;
    UISegmentedControl * _viewSelector;
    
    UIBarButtonItem * _exposeButton;
    UIBarButtonItem * _documentListButton;
    
    UITapGestureRecognizer *_singleTapRecognizer;
    UITapGestureRecognizer *_titleDoubleTapGestureRecognizer;
    
    PPDocumentView * _currentView;
    UIViewController * _currentViewController;
}

@property (assign, nonatomic) BOOL isTitleDoubleTapToEditGestureEnabled;
@property (assign, nonatomic) NSUInteger selectedView;
@property (strong, nonatomic) NSArray * views;

- (void)loadDocumentViews;
- (void)startEditingTitle;
- (void)endEditingTitle;
- (void)save;

@end
