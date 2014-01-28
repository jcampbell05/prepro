//
//  PPScriptViewController.h
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "PPScriptFormatter.h"
#import "WYPopoverController.h"
#import "PPTextView.h"

@interface PPScriptViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *formatters;
    
    UIToolbar * toolbar;
    
    UITableViewController *typePicker;
    UIBarButtonItem *typeButton;
    
    UITextField * titleTextField;
    PPTextView * textView;
    
    UITapGestureRecognizer * titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer * singleTapRecognizer;
    
    WYPopoverController *popoverController;
    
    PPScriptFormatter * currentFormatter;
}

@property (strong, atomic) Script * script;

- (void)startEditingTitle;
- (void)endEditingTitle;
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
