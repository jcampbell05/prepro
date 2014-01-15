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

@interface PPScriptViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    NSArray *formatters;
    
    UIToolbar * toolbar;
    UISegmentedControl * typePicker;
    
    UITextField * titleTextField;
    UITextView * textView;
    
    UITapGestureRecognizer * titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer * singleTapRecognizer;
    
    PPScriptFormatter * currentFormatter;
}

@property (strong, atomic) Script * script;

- (void)startEditingTitle;
- (void)endEditingTitle;
- (void)dismissKeyboard;
- (void)save;
- (void)typePickerChanged:(UISegmentedControl *)sender;
- (void)setCurrentFormatter:(PPScriptFormatter *)formatter;

@end
