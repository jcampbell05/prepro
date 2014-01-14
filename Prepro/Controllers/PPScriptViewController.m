//
//  PPScriptViewController.m
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptViewController.h"
#import "MBAlertView.h"
#import "PPScriptSectionTypeSelectorViewController.h"

@interface PPScriptViewController ()

@end

@implementation PPScriptViewController

- (void)loadView {
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(37,7, 100,35)];
    titleTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleTextField.backgroundColor = [UIColor clearColor];
    titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleTextField.delegate = self;
    titleTextField.enabled  = NO;
    titleTextField.font = [UIFont systemFontOfSize:20.0];
    titleTextField.opaque = NO;
    titleTextField.textAlignment = NSTextAlignmentCenter;
    titleTextField.textColor = [UIColor whiteColor];
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = titleTextField;
    
    textView = [[UITextView alloc] init];
    
    toolbar = [[UIToolbar alloc] init];
    
    typeButton = [[UIBarButtonItem alloc] initWithTitle:@"Type" style:UIBarButtonItemStylePlain target:self action:@selector(showSectionTypeSelector:)];
    
    [toolbar sizeToFit];
    [toolbar setItems:@[typeButton]];
    
    textView.inputAccessoryView = toolbar;
    
    self.view = textView;
}

- (void)viewWillAppear:(BOOL)animated {
    titleTextField.text = _script.name;
    
    titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingTitle)];
    titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [titleTextField addGestureRecognizer:titleDoubleTapGestureRecognizer];
    
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTapRecognizer.numberOfTapsRequired = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
 
}

- (void)textViewDidChange:(UITextView *)textView {
    _script.content = textView.text;
}

- (void)startEditingTitle {
    titleTextField.enabled = YES;
    [titleTextField becomeFirstResponder];
    
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)endEditingTitle {
    [titleTextField resignFirstResponder];
    titleTextField.enabled = NO;
    
    _script.name = titleTextField.text;
    
    [self.view removeGestureRecognizer:singleTapRecognizer];
    
    NSError *error;
    if(![_script save:&error]){
        NSLog(@"Error saving script.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Script saved.");
    }
}

- (void)dismissKeyboard {
    [self endEditingTitle];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ( [string isEqualToString:@"\n"] ){
        
        if ( titleTextField.text.length == 0 ){
            [[MBAlertView alertWithBody:@"Please enter a project title" cancelTitle:@"Continue" cancelBlock:^{
                [self startEditingTitle];
            }] addToDisplayQueue];
        } else {
            [self endEditingTitle];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)showSectionTypeSelector:(id)sender {
    
    PPScriptSectionTypeSelectorViewController * sectionTypeSelectorViewController = [[PPScriptSectionTypeSelectorViewController alloc] init];
    sectionTypeSelectorViewController.cancelBlock = ^{
        [popoverController dismissPopoverAnimated:YES];
    };
    
    UINavigationController * navicationController = [[UINavigationController alloc] initWithRootViewController:sectionTypeSelectorViewController];
    
    /*Display it in pop over*/
    popoverController = [[WYPopoverController alloc] initWithContentViewController:navicationController];
    
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];
    [self.view bringSubviewToFront:popoverController.contentViewController.view];
}

@end
