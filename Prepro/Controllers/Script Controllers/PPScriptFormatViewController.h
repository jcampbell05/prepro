//
//  PPScriptFormatViewController.h
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPScriptFormatMenuViewController.h"
#import "PPScriptFormatViewControllerDelegate.h"

@interface PPScriptFormatViewController : UIViewController {
    NSArray * _formatters;
    
    UINavigationController * _navigationController;
    
    PPScriptFormatMenuViewController * _formatMenuViewController;
    
    CGRect _preKeyboardRect;
}

@property (unsafe_unretained, atomic) id<PPScriptFormatViewControllerDelegate> delegate;

- (id)initWithFormatters:(NSArray *)formatters andDelegate:(id<PPScriptFormatViewControllerDelegate>) delegate;
- (void)addScriptSection;
- (void)editScriptSection:(PPScriptSection *)section;

@end
