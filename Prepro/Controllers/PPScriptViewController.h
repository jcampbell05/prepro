//
//  PPScriptViewController.h
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "WYPopoverController.h"

@interface PPScriptViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    UIToolbar * toolbar;
    UIBarButtonItem * typeButton;
    
    UITextField * titleTextField;
    UITextView * textView;
    
    UITapGestureRecognizer * titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer * singleTapRecognizer;
    
    WYPopoverController * popoverController;
}

@property (strong, atomic) Script * script;

- (void)startEditingTitle;
- (void)endEditingTitle;
- (void)dismissKeyboard;
- (void)showSectionTypeSelector:(id)sender;

@end
