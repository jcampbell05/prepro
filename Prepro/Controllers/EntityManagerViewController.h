//
//  EntityManagerViewController.h
//  Prepro
//
//  Created by James Campbell on 07/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Fix Edit button being enabled on Empty Tableview

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NSObject+AppDelegate.h"
#import "Document.h"
#import "WYPopoverController.h"
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface EntityManagerViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate, MFMailComposeViewControllerDelegate> {
    
    WYPopoverController *popoverController;
    
    UIBarButtonItem * _exposeButton;
    UIBarButtonItem * _documentListButton;
    
    UIBarButtonItem * editModeButtonBar;
    UIBarButtonItem * deleteEntitiesButton;
    UIBarButtonItem * decodeHireButton;
    
    UILabel * selectedCount;
    NSArray * toolbarItems;
    
    NSArray * categories;
    NSIndexPath * placeholderIndexPath;
}

@property (atomic, strong) Document * document;
@property (readonly) NSArray * entities;
@property (assign) bool allowsBatchEntry;
@property (nonatomic, strong) JTTableViewGestureRecognizer * tableViewRecognizer;

- (void)updateCategories;
- (void)syncTableView;
- (void)newEntity;
- (void)toggleEditMode;
- (void)updateButtons;
- (void)updateToolbar;
- (void)removeEntities;
- (void)showBatchEntityPopover:(id)sender forEvent:(UIEvent*)event;
- (void)editEntity:(id)entity;
- (void)saveProject; //TODO: Abstract This, so it only saves Entity ?

//TODO: Create Reusable Method for deleting things.

- (NSArray *)categoriesExcludeEmpty:(bool)exclude;
- (EntityCategory *)categoryForSection:(int)section excludeEmpty:(bool)exclude;

@end
