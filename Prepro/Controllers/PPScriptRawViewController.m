//
//  PPScriptRawViewController.m
//  Prepro
//
//  Created by James Campbell on 05/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptRawViewController.h"

@interface PPScriptRawViewController ()

- (void)createAccesoryToolbar;

@end

@implementation PPScriptRawViewController

#pragma mark UIViewController Lifecycle

- (void)loadView {
    
    _textView = [[PPTextView alloc] init];
    _textView.delegate = self;
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [self createAccesoryToolbar];
    
    self.view = _textView;
}


- (void)viewWillAppear:(BOOL)animated {
    _textView.text = _script.content;
}

#pragma mark Implementation 

- (void)createAccesoryToolbar {
    _textViewAccesoryToolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:_textView action:@selector(resignFirstResponder)];
    
    [_textViewAccesoryToolbar setItems:@[flexibleSpace, doneButton]];
    [_textViewAccesoryToolbar sizeToFit];
    
    _textView.inputAccessoryView = _textViewAccesoryToolbar;
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    _script.content = _textView.text;
}

@end
