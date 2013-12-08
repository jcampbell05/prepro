//
//  PPTimeCodeElement.m
//  Prepro
//
//  Created by James Campbell on 22/07/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPTimeCodeElement.h"

@implementation PPTimeCodeElement

- (QEntryElement *)init {
    self = [super init];
    if (self){
        _inputView = [[PPTimeCodeInputView alloc] init];
    }
    return self;
}


- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    
    QEntryTableViewCell *cell = (QEntryTableViewCell *)[super getCellForTableView:tableView controller:controller];
    
    cell.textField.inputView = _inputView;
    cell.textField.delegate = self;
    cell.textField.clearButtonMode = UITextFieldViewModeNever;

    _inputView.input = cell.textField;
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_inputView updateValue];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.textValue = textField.text;
}


- (void)fetchValueIntoObject:(id)obj
{
	if (_key == nil) {
		return;
	}
	[obj setValue:self.textValue forKey:_key];
}


@end
