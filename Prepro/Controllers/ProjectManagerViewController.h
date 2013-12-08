//
//  ProjectManagerViewController.h
//  Prepro
//
//  Created by James Campbell on 22/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FPPicker/FPPicker.h>
#import "ProjectViewController.h"
#import "PPExposeController.h"

#define ProjectManagerViewCollectionViewCellWidth 100
#define ProjectManagerViewCollectionViewCellHeight 150

@interface ProjectManagerViewController : UICollectionViewController<FPPickerDelegate> {
    UIBarButtonItem *editProjectsButton;
    UIBarButtonItem *deleteProjectsButton;
    UILabel *selectedCount;
    NSArray *toolbarItems;
    
    NSArray *projects;
    
    PPExposeController *exposeController;
}

- (void)newProject;
- (void)importProject;
- (BOOL)loadProjects;
- (void)toggleProjectEditMode;
- (void)projectSelectedAtCellIndexPath:(NSIndexPath *)indexPath;
- (void)removeProjects;
- (void)updateButtons;
- (void)updateToolbar;
- (void)showProject: (Project *)project fromIndex:(NSIndexPath *)indexPath;
- (void)closeProject;
- (void)updateWithForce:(BOOL)force;

@end
