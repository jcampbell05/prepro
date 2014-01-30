//
//  PPScriptViewController.h
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Refactor

#import <UIKit/UIKit.h>
#import "PPDocumentViewController.h"
#import "Script.h"
#import "PPScriptFormatter.h"
#import "WYPopoverController.h"
#import "PPTextView.h"

@interface PPScriptViewController : PPDocumentViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *formatters;
    
    UIToolbar * toolbar;
    
    UITableViewController *typePicker;
    UIBarButtonItem *typeButton;
    
    PPTextView * textView;
    
    NSMutableString * rawContent;
    
    WYPopoverController *popoverController;
    
    PPScriptFormatter * currentFormatter;
}

@property (strong, atomic) Script * script;

- (void)dismissKeyboard;
- (void)save;
- (void)updateCurrentFormatter;
- (void)setCurrentFormatter:(NSUInteger)idx;
- (void)reformatCurrentLine;
- (void)nextLineFormatter;
- (void)typePressed:(UIBarButtonItem *)sender;

- (int)indexOfNewLineBeforeCaret;
- (int)indexOfNewLineAfterCaret;

@end
