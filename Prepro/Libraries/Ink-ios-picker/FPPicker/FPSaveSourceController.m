//
//  FPSaveSourceController.m
//  FPPicker
//
//  Created by Liyan David Chang on 7/8/12.
//  Copyright (c) 2012 Filepicker.io (Couldtop Inc.). All rights reserved.
//

#import "FPSaveSourceController.h"

@interface FPSaveSourceController ()

@property (strong) UITextField *textField;
@property (strong) UIBarButtonItem* saveButton;

@end

@implementation FPSaveSourceController

@synthesize textField, saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSLog(@"Source: %@ Path: %@ %@", self.sourceType.identifier, self.path, [NSString stringWithFormat:@"%@/", self.sourceType.rootUrl]);
    if ((self.sourceType.identifier == FPSourceFacebook || self.sourceType.identifier == FPSourcePicasa) && [self.path isEqualToString:[NSString stringWithFormat:@"%@/", self.sourceType.rootUrl]]){
        NSLog(@"SPECIAL");
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 0.0, 200, 21.0)];
            [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextColor:[UIColor whiteColor]];
            [titleLabel setText:@"Choose an Album"];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
            [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, title, flexibleSpace, nil]];
            
        } else {
            FPSaveController *fpsave = (FPSaveController *)self.fpdelegate;

            self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
                        
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 31)];
            [textField setPlaceholder:@"filename"];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setClipsToBounds:YES];
            [textField setDelegate:self];
            
            if (fpsave.proposedFilename != nil){
                textField.text = fpsave.proposedFilename;
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
            
            label.text = [fpsave getExtensionString];
            label.textColor = [UIColor grayColor];
            
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.rightView = label;
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setReturnKeyType:UIReturnKeyDone];
            
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            UIBarButtonItem *filename = [[UIBarButtonItem alloc] initWithCustomView:textField];
            
            [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, filename, saveButton, nil]];
        }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    FPSaveController *fpsave = (FPSaveController *)self.fpdelegate;
    if (fpsave.proposedFilename != nil){
        textField.text = fpsave.proposedFilename;
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    if (textField.text != nil){
        FPSaveController *fpsave = (FPSaveController *)self.fpdelegate;
        fpsave.proposedFilename = textField.text;
    }
}


- (void)keyboardWillShow:(NSNotification *)notification {
    if (fpDEVICE_TYPE == fpDEVICE_TYPE_IPHONE){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect frame = self.navigationController.toolbar.frame;
        frame.origin.y = frame.origin.y - 216;
        self.navigationController.toolbar.frame = frame;
        
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (fpDEVICE_TYPE == fpDEVICE_TYPE_IPHONE){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect frame = self.navigationController.toolbar.frame;
        frame.origin.y = frame.origin.y + 216;
        self.navigationController.toolbar.frame = frame;
        
        [UIView commitAnimations];
    }
}

- (void) saveAction:(id)sender {
    [self.fpdelegate FPSourceController:self didPickMediaWithInfo:[NSDictionary alloc]];
    
    NSLog(@"Path %@",self.path);
    FPSaveController *saveC = (FPSaveController *) self.fpdelegate;
    [saveC saveFileName:self.textField.text To:self.path];
}

- (void) objectSelectedAtIndex:(NSInteger) index {
    NSMutableDictionary *obj = [self.contents objectAtIndex:index];
    
    if ([[NSNumber numberWithInt:1] isEqualToNumber:[obj valueForKey:@"is_dir"]]){
        FPSaveSourceController *subController = [[FPSaveSourceController alloc] init];
        subController.path = [obj valueForKey:@"link_path"];
        subController.sourceType = self.sourceType;
        subController.fpdelegate = self.fpdelegate;
        [self.navigationController pushViewController:subController animated:YES];
        return;
    } else {
        self.textField.text = [[obj valueForKey:@"filename"] stringByDeletingPathExtension];
        [self textFieldDidChange:self.textField];
    }
    
    NSLog(@"selected");
    return;
}

- (void) objectSelectedAtIndex:(NSInteger) index withThumbnail:(UIImage *) thumbnail {
    [self objectSelectedAtIndex:index];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveAction:nil];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self updateTextFieldButton];
}

- (void)updateTextFieldButton {
    if (self.sourceType.overwritePossible){
        //If it can overwite, warn the user.
        
        for (NSMutableDictionary *obj in self.contents){
            FPSaveController *saveC = (FPSaveController *) self.fpdelegate;
            NSString* proposedName = [self.textField.text stringByAppendingString:[saveC getExtensionString]];
            if ([[obj valueForKey:@"filename"] isEqualToString:proposedName]){
                self.saveButton.title = @"Overwrite";
                if ([fpDEVICE_VERSION doubleValue] >= 5.0){
                    self.saveButton.tintColor = [UIColor redColor];
                }
                CGRect frameRect = self.textField.frame;
                frameRect.size.width = 183;
                self.textField.frame = frameRect;
                
                return;
            }
        }
        //reset to default
        self.saveButton.title = @"Save";
        if ([fpDEVICE_VERSION doubleValue] >= 5.0){
            NSLog(@">=version5");
            self.saveButton.tintColor = nil;
        }
        CGRect frameRect = self.textField.frame;
        frameRect.size.width = 210;
        self.textField.frame = frameRect;
    }
}

- (void) afterReload {
    [self updateTextFieldButton];
    [super afterReload];
}

@end
