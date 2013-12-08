//
//  ProjectViewController.h
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FPPicker/FPPicker.h>
#import "NSObject+AppDelegate.h"
#import "UIViewController+ADFlipTransition.h"
#import "Project.h"

@class ProjectManagerViewController;
@interface ProjectViewController : UITableViewController<UITextFieldDelegate, FPSaveDelegate> {
    UITextField *titleTextField;
    UITapGestureRecognizer *titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer *singleTapRecognizer;
}

@property (readonly, strong, nonatomic) NSArray *documents;
@property (strong, nonatomic) ProjectManagerViewController * projectManagerViewController;

- (void)startEditingProjectTitle;
- (void)endEditingProjectTitle;
- (void)saveProject;
- (void)exportProject;
- (void)dismissKeyboard;
- (IBAction)backPressed:(UIButton *)sender;

@end
