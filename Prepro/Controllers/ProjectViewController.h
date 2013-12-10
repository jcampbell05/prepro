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
#import "PPPanelViewControllerDelegate.h"
#import "WYPopoverController.h"

//TODO: Revamp code so it doesn't save Project multiple times due to new Tab System.

@class ProjectManagerViewController;
@interface ProjectViewController : UITableViewController<UITextFieldDelegate, FPSaveDelegate, PPPanelViewControllerDelegate> {
    
    WYPopoverController *popoverController;
    
    UITextField *titleTextField;
    UITapGestureRecognizer *titleDoubleTapGestureRecognizer;
    UITapGestureRecognizer *singleTapRecognizer;
    
    NSIndexPath *currentDocument;
}

@property (readonly, strong, nonatomic) NSArray *documents;
@property (strong, nonatomic) ProjectManagerViewController * projectManagerViewController;

- (void)showTabs;
- (void)startEditingProjectTitle;
- (void)endEditingProjectTitle;
- (void)saveProject:(id)sender;
- (void)exportProject;
- (void)dismissKeyboard;
- (IBAction)backPressed:(UIButton *)sender;

@end
