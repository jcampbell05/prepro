//
//  PPScriptRawViewController.h
//  Prepro
//
//  Created by James Campbell on 05/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "PPTextView.h"

@interface PPScriptRawViewController : UIViewController <UITextViewDelegate> {
    UIToolbar * _textViewAccesoryToolbar;
    PPTextView * _textView;
}

@property (strong, nonatomic) Script * script;

@end
