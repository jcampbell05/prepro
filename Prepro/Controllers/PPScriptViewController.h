//
//  PPScriptViewController.h
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"

@interface PPScriptViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    UITextField * titleTextField;
    UITextView * textView;
    
    UITapGestureRecognizer *titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer *singleTapRecognizer;
}

@property (strong, atomic) Script * script;

- (void)startEditingTitle;
- (void)endEditingTitle;
- (void)dismissKeyboard;

@end
