//
//  PPAppDelegate.h
//  Prepro
//
//  Created by James Campbell on 22/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNavigationViewController.h"
#import "Project.h"

//TODO: Add sharedAppDelegate, Move to XML Data Model with Squirrel Scripting :) Move to something as good as IBA Forms ut as powerful as Quick Dialog.
@interface PPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) Project *currentProject;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootNavigationViewController *navigationController;

@property (readonly, strong, nonatomic) NSArray *documents;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
