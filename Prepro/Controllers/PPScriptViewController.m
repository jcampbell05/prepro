//
//  PPScriptViewController.m
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptViewController.h"
#import "MBAlertView.h"
#import "PPScriptActionFormatter.h"
#import "PPScriptCharacterFormatter.h"
#import "PPScriptDialogueFormatter.h"
#import "PPScriptParenthesesFormatter.h"
#import "PPScriptSceneFormatter.h"

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
    
    formatters = @[
        [PPScriptSceneFormatter alloc],
        [PPScriptActionFormatter alloc],
        [PPScriptCharacterFormatter alloc],
        [PPScriptDialogueFormatter alloc],
        [PPScriptParenthesesFormatter alloc]
    ];
    
    NSMutableArray * typePickerItems = [[NSMutableArray alloc] init];
    
    [formatters enumerateObjectsUsingBlock:^(PPScriptFormatter * formatter, NSUInteger idx, BOOL *stop) {
        [typePickerItems addObject:[formatter title]];
    }];
    
    typePicker = [[UISegmentedControl alloc] initWithItems:[typePickerItems copy]];
    [typePicker addTarget:self action:@selector(typePickerChanged:) forControlEvents:UIControlEventValueChanged];
    typePicker.selectedSegmentIndex = 0;
    [self typePickerChanged: typePicker];
    
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0" )) {
        typePicker.tintColor = [UIColor whiteColor];
    }
    
    UIBarButtonItem *typePickerWrapper = [[UIBarButtonItem alloc] initWithCustomView:typePicker];
    
    [toolbar sizeToFit];
    [toolbar setItems:@[typePickerWrapper]];
    
    textView.inputAccessoryView = toolbar;
    textView.delegate = self;
    
    self.view = textView;
}

- (void)viewWillAppear:(BOOL)animated {
    titleTextField.text = _script.name;
    textView.attributedText = _script.content;
    
    titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingTitle)];
    titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [titleTextField addGestureRecognizer:titleDoubleTapGestureRecognizer];
    
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTapRecognizer.numberOfTapsRequired = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self save];
}

- (void)startEditingTitle {
    titleTextField.enabled = YES;
    [titleTextField becomeFirstResponder];
    
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)endEditingTitle {
    [titleTextField resignFirstResponder];
    titleTextField.enabled = NO;
    
    [self.view removeGestureRecognizer:singleTapRecognizer];
    [self save];
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

- (void)save {
    _script.name =  titleTextField.text;
    _script.content = textView.attributedText;
    
    NSError *error;
    if(![_script save:&error]){
        NSLog(@"Error saving script.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Script saved.");
    }
}

- (void)typePickerChanged:(UISegmentedControl *)sender {
    [self setCurrentFormatter:sender.selectedSegmentIndex];
}

-(void)updateCurrentFormatter {
    [formatters enumerateObjectsUsingBlock:^(PPScriptFormatter * formatter, NSUInteger idx, BOOL *stop) {
        if ( [textView.typingAttributes[@"type"] isEqualToString:[formatter title]] ) {
            [self setCurrentFormatter:idx];
            *stop = YES;
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateCurrentFormatter];
}

- (void)setCurrentFormatter:(NSUInteger)idx{
    currentFormatter = formatters[idx];
    typePicker.selectedSegmentIndex = idx;
    textView.typingAttributes = [currentFormatter attributes];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self updateCurrentFormatter];
}


//Maybe override so user has to hit tab or next/prev ?
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (text.length == 0) {
        
        //Checkline before isn't \n if it is then reset formatting
        
        return YES;
    }
    
    text = [currentFormatter transformInput:text];
    [textView replaceRange:textView.selectedTextRange withText:text];
    
    if ( [text isEqualToString:@"\n"] ) {
        
        //Check we didnt take some of the text after the carriage return, if we did then re-format it
        
        [self nextLineFormatter];
    }
    
    return NO;
}

- (void)nextLineFormatter {
    Class nextFormatterClass = [currentFormatter formatterForNextLine];
    
    [formatters enumerateObjectsUsingBlock:^(PPScriptFormatter * formatter, NSUInteger idx, BOOL *stop) {
        if ( nextFormatterClass == [formatter class] ) {
            [self setCurrentFormatter:idx];
            *stop = YES;
        }
    }];
}

@end
