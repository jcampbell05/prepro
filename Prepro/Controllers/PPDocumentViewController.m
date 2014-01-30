//
//  PPDocumentViewController.m
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPDocumentViewController.h"

@interface PPDocumentViewController ()

- (void)createTitleView;
- (void)attachSingleTapRecognizer;
- (void)attachTitleViewDoubleTapGesture;

@end

@implementation PPDocumentViewController

#pragma mark UIViewController Lifecycle

- (id)init {
    
    if ( self = [super init] ) {
        _isTitleDoubleTapToEditGestureEnabled = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self attachTitleViewDoubleTapGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self save];
}

#pragma mark PPDocumentViewController Implementation

- (void)setTitle:(NSString *)title {
    _titleTextField.text = title;
}

- (NSString *)title {
    return _titleTextField.text;
}

- (void)setIsTitleDoubleTapToEditGestureEnabled:(BOOL)isTitleDoubleTapToEditGestureEnabled {
    _titleDoubleTapGestureRecognizer.enabled = _isTitleDoubleTapToEditGestureEnabled;
}

- (void)createTitleView {
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(37,7, 100,35)];
    _titleTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _titleTextField.backgroundColor = [UIColor clearColor];
    _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleTextField.delegate = self;
    _titleTextField.enabled  = NO;
    _titleTextField.font = [UIFont systemFontOfSize:20.0];
    _titleTextField.opaque = NO;
    _titleTextField.textAlignment = NSTextAlignmentCenter;
    _titleTextField.textColor = [UIColor whiteColor];
    _titleTextField.returnKeyType = UIReturnKeyDone;
    _titleTextField.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = _titleTextField;
}

- (void)attachSingleTapRecognizer {
    _singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingTitle)];
    _singleTapRecognizer.enabled = NO;
    _singleTapRecognizer.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:_singleTapRecognizer];
}

- (void)attachTitleViewDoubleTapGesture {
    
    if ( _titleDoubleTapGestureRecognizer != nil) {
        _titleDoubleTapGestureRecognizer = nil;
    }
    
    _titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    _titleDoubleTapGestureRecognizer.enabled = _isTitleDoubleTapToEditGestureEnabled;
    _titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    [_titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingTitle)];
    [_titleTextField addGestureRecognizer:_titleDoubleTapGestureRecognizer];
}

- (void)startEditingTitle {
    _titleTextField.enabled  = YES;
    _singleTapRecognizer.enabled = YES;
    
    [_titleTextField becomeFirstResponder];
}

- (void)endEditingTitle {
    [_titleTextField resignFirstResponder];
}

- (void)save {
   
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _titleTextField ) {
        
        _titleTextField.enabled = NO;
        _singleTapRecognizer.enabled = NO;
        
        [self attachTitleViewDoubleTapGesture];
        [self save];
    }
    
}

@end
