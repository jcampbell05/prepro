//
//  PPTimeCodeInputView.h
//  Prepro
//
//  Created by James Campbell on 14/08/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTimeCodeInputView : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, atomic) UITextField *input;

- (bool)isSeperatorComponent:(NSInteger)component;
- (void)updateValue;

@end
