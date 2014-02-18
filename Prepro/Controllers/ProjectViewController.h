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
#import "PPDocumentViewController.h"
#import "WYPopoverController.h"
#import "PPExportDataSource.h"

//TODO: Revamp code so it doesn't save Project multiple times due to new Tab System. Also make it use new Document View Controller Class.

@class ProjectManagerViewController;
@interface ProjectViewController : PPDocumentViewController<UITextFieldDelegate, FPSaveDelegate, PPPanelViewControllerDelegate, PPExportDataSource, UITableViewDataSource, UITableViewDelegate> {
    
    WYPopoverController *popoverController;
    
    NSIndexPath *currentDocument;
}

@property (readonly, strong, nonatomic) NSArray *documents;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) ProjectManagerViewController * projectManagerViewController;

- (void)showTabs;
- (void)saveProject:(id)sender;
- (void)exportProject;
- (void)dismissKeyboard;
- (IBAction)backPressed:(UIButton *)sender;

@end
