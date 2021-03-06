//
//  ProjectManagerViewController.h
//  Prepro
//
//  Created by James Campbell on 22/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Refactor

#import <UIKit/UIKit.h>
#import <FPPicker/FPPicker.h>
#import "ProjectViewController.h"
#import "PPExposeController.h"
#import "WYPopoverController.h"
#import "IASKAppSettingsViewController.h"

#define ProjectManagerViewCollectionViewCellWidth 100
#define ProjectManagerViewCollectionViewCellHeight 150

@interface ProjectManagerViewController : UICollectionViewController<FPPickerDelegate, UIScrollViewDelegate, IASKSettingsDelegate> {
    
    WYPopoverController *popoverController;
    
    UIBarButtonItem *editProjectsButton;
    UIBarButtonItem *deleteProjectsButton;
    UILabel *selectedCount;
    NSArray *toolbarItems;
    
    NSArray *projects;
    
    PPExposeController *exposeController;
}

- (void)newProject;
- (void)importProject:(id)sender;
- (BOOL)loadProjects;
- (void)showSettings:(id)sender;
- (void)toggleProjectEditMode:(UIBarButtonItem *)sender;
- (void)projectSelectedAtCellIndexPath:(NSIndexPath *)indexPath;
- (void)removeProjects;
- (void)updateButtons;
- (void)updateToolbar;
- (void)showProject: (Project *)project fromIndex:(NSIndexPath *)indexPath;
- (void)closeProject;
- (void)updateWithForce:(BOOL)force;

@end
