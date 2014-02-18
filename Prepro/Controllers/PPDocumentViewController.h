//
//  PPDocumentViewController.h
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Switch Document Screens to use this

#import <UIKit/UIKit.h>
#import "PPDocumentView.h"

@interface PPDocumentViewController : UIViewController<UITextFieldDelegate> {
    UITextField * _titleTextField;
    UISegmentedControl * _viewSelector;
    
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
- (void)willSwitchToDocumentView:(PPDocumentView *)documentView;
- (void)didSwitchToDocumentView:(PPDocumentView *)documentView;
- (void)save;

@end
