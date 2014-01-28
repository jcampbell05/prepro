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
#import "PPScriptParentheticalFormatter.h"
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
    
    textView = [[PPTextView alloc] init];
    toolbar = [[UIToolbar alloc] init];
    
    formatters = @[
        [PPScriptSceneFormatter alloc],
        [PPScriptActionFormatter alloc],
        [PPScriptCharacterFormatter alloc],
        [PPScriptDialogueFormatter alloc],
        [PPScriptParentheticalFormatter alloc]
    ];
    
    typeButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(typePressed:)];
    
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0" )) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar sizeToFit];
    [toolbar setItems:@[typeButton, flexibleItem, doneButton]];
    
    textView.inputAccessoryView = toolbar;
    textView.delegate = self;
    
    [self setCurrentFormatter: 0];
    
    self.view = textView;
}

- (void)viewWillAppear:(BOOL)animated {
    titleTextField.text = _script.name;
    textView.attributedText = _script.content;
    
    titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingTitle)];
    titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [titleTextField addGestureRecognizer:titleDoubleTapGestureRecognizer];
    
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingTitle)];
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
    [textView resignFirstResponder];
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

- (void)setCurrentFormatter:(NSUInteger)idx {
    
    currentFormatter = formatters[idx];
    textView.typingAttributes = [currentFormatter attributes];
    
    [typeButton setTitle: [NSString stringWithFormat:@"Type: %@", [currentFormatter title]] ];
}

- (void)reformatCurrentLine {
    
    UITextRange * selectedTextRange = textView.selectedTextRange;
    
    NSMutableAttributedString *mutableAttributedString = [textView.attributedText mutableCopy];
    [mutableAttributedString setAttributes:[currentFormatter attributes] range:[textView rangeForCurrentLine]];
    textView.attributedText = mutableAttributedString;
    
    textView.selectedTextRange = selectedTextRange;
}

//Maybe override so user has to hit tab or next/prev ?
- (BOOL)textView:(PPTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (text.length == 0) {

        //Checkline before isn't \n if it is then reset formatting
        if ( textView.text.length > range.location && [[textView.text substringWithRange:NSMakeRange(range.location - 1, range.length)] isEqualToString:@"\n"] ) {
            
            PPScriptFormatter * oldFormetter = currentFormatter;
            
            [textView deleteBackward];
            
            textView.typingAttributes = [oldFormetter attributes];

            [self updateCurrentFormatter];
            
            return NO;
        }
        
        [self updateCurrentFormatter];
        
        return YES;
    }
    
    text = [currentFormatter transformInput:text];
    [textView replaceRange:textView.selectedTextRange withText:text];
    
    if ([text isEqualToString:@"\n"]) {
        [self nextLineFormatter];
    }
    
    [self updateCurrentFormatter];
    
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

- (void)typePressed:(UIBarButtonItem *)sender {
    
    if (popoverController == nil) {
        
        typePicker = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        typePicker.tableView.delegate = self;
        typePicker.tableView.dataSource = self;
        
        popoverController = [[WYPopoverController alloc] initWithContentViewController:typePicker];
    }
    
    if ( ![popoverController isPopoverVisible] ) {
        
        [typePicker.tableView reloadData];
        
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        [popoverController dismissPopoverAnimated:YES];
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [popoverController dismissPopoverAnimated:YES];
    [self setCurrentFormatter:indexPath.row];
    [self reformatCurrentLine];
}

#pragma mark UITableViewDataSource

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [formatters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PPScriptFormatter * formatter = formatters[ indexPath.row ];
    
    cell.textLabel.text = formatter.title;
    
    if (formatter == currentFormatter) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
