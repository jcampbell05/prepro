//
//  BatchNumberPickerViewController.m
//  Prepro
//
//  Created by James Campbell on 07/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "BatchNumberPickerViewController.h"

@interface BatchNumberPickerViewController ()

@end

@implementation BatchNumberPickerViewController

- (void)viewDidLoad {
    self.view.frame = CGRectMake(0,0, 250, 100);
    
    int componentsWidth = 95;
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Add %@", [_document plural]]];
    [self.navigationItem setPrompt:[NSString stringWithFormat:@"Enter the number of %@ to add.", [_document plural]]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addPressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditingTextField)];
    
    [toolbar setItems:@[flex, doneButton]];
    [toolbar sizeToFit];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - componentsWidth) / 2, 10.0, componentsWidth, 75)];
    _textField.inputAccessoryView = toolbar;
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.font = [UIFont systemFontOfSize:50];
    _textField.minimumFontSize = 20.0f;
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    _stepper = [[UIStepper alloc] initWithFrame:CGRectMake((self.view.frame.size.width - componentsWidth) / 2, 85, componentsWidth, 50)];
    _stepper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _stepper.minimumValue = 1;
    _stepper.maximumValue = INT32_MAX;
    [_stepper addTarget:self action:@selector(stepperPressed) forControlEvents:UIControlEventValueChanged];
    _stepper.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:_textField];
    [self.view addSubview:_stepper];
    
    self.value = 1;
}

- (void)setValue:(NSInteger)value {
    
    if (value < 1) {
        value = 1;
    }
    
    _value = value;
    _textField.text = [NSString stringWithFormat:@"%i", value];
}

- (void)doneEditingTextField {
    [_textField resignFirstResponder];
    _textField.text = [NSString stringWithFormat:@"%i", _value];
    _stepper.value = _value;
}

- (void)textFieldChanged {
    _value = [_textField.text integerValue];
    _stepper.value = _value;
}

- (void)stepperPressed {
    self.value = _stepper.value;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //If this is a backspace character then
    if (string.length == 0) {
        //it can be replaced
        return YES;
    }
    
    //Create Regular Expression to detect numbers, this is used for making sure the string about to be replaced is a number
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"([0-9])" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //If the string about to be replaced is a number then
    if ([regex matchesInString:string options:0 range:NSMakeRange(0, string.length)].count > 0){
        //text can be replaced
        return YES;
    }
    
    //If the above checks have failed then nothing can be replaced
    return NO;
}

- (void)addPressed {
    _addBlock(_value);
}

- (void)cancelPressed {
    _cancelBlock();
}

- (CGSize)contentSizeForViewInPopover {
    return CGSizeMake(300, 180);
}

@end
