//
//  BatchNumberPickerViewController.h
//  Prepro
//
//  Created by James Campbell on 07/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

typedef void (^BatchNumberPickerAddBlock)(int);
typedef void (^BatchNumberPickerCancelBlock)();

@interface BatchNumberPickerViewController : UIViewController<UITextFieldDelegate>

@property (assign, nonatomic) Document * document;
@property (assign, nonatomic) NSInteger value;
@property (strong, nonatomic )UITextField *textField;
@property (strong, nonatomic) UIStepper *stepper;
@property (copy, nonatomic) BatchNumberPickerAddBlock addBlock;
@property (copy, nonatomic) BatchNumberPickerCancelBlock cancelBlock;

- (void)doneEditingTextField;
- (void)textFieldChanged;
- (void)stepperPressed;
- (void)addPressed;
- (void)cancelPressed;

@end
