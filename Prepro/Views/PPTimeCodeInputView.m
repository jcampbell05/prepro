//
//  PPTimeCodeInputView.m
//  Prepro
//
//  Created by James Campbell on 14/08/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPTimeCodeInputView.h"

#define SeperatorComponents @[@1,@4]

@implementation PPTimeCodeInputView

- (id)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        for (int i = 0; i < [self numberOfComponents]; i++) {
            [self selectRow:4440 inComponent:i animated:NO];
        }
    }
    return self;
}

- (void)updateValue {
    NSString *timeCodeString = _input.text;
    
    if (timeCodeString.length > 0){
        
        for (int i = 0; i < [self numberOfComponents]; i++) {
            if ( ![self isSeperatorComponent:i] ) {
                NSString *character = [timeCodeString substringWithRange:NSMakeRange(i, 1)];
                [self selectRow:4440 + [character integerValue] inComponent:i animated:NO];
            }
        }
        
    }
}

- (bool)isSeperatorComponent:(NSInteger)component{
    return [SeperatorComponents containsObject:@(component)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 7;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if ( [self isSeperatorComponent:component] ) {
        return 1;
    } else {
        return 9999;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 30.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ( [self isSeperatorComponent:component] ) {
        return @":";
    } else {
        return [NSString stringWithFormat:@"%i", row % 10];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ( ![self isSeperatorComponent:component] ) {
        int rowValue = row % 10;
        [self selectRow:4440 + rowValue inComponent:component animated:NO];
        
        NSString *value = @"";
        for (int i = 0; i < [self numberOfComponents]; i++) {
            int selectedRow = [self selectedRowInComponent:i];
            NSString *rowTitle = [self pickerView:self titleForRow:selectedRow forComponent:i];
            
            value = [NSString stringWithFormat:@"%@%@", value, rowTitle];
        }
        
        _input.text = value;
    }
}

@end
