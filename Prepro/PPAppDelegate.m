//
//  PPAppDelegate.m
//  Prepro
//
//  Created by James Campbell on 22/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//


//TODO: Reduce these Imports
#import "Crittercism.h"
#import "PPAppDelegate.h"
#import "PPAppStyleManager.h"
#import "PPAppStyle.h"
#import "ProjectManagerViewController.h"
#import "ProposalDocument.h"
#import "ShotListDocument.h"
#import "EquipmentListDocument.h"
#import "CastDocument.h"
#import "CrewDocument.h"
#import "ScriptDocument.h"
#import "StoryboardDocument.h"
#import "SoundtrackDocument.h"
#import "CharacterProfilesDocument.h"
#import "ContingencyPlansDocument.h"
#import "ShootingDatesDocument.h"
#import "LocationListDocument.h"
#import "PropListDocument.h"
#import "BudgetDocument.h"
#import "NotesDocument.h"
#import "LogBookDocument.h"
#import "RiskAssessmentDocument.h"
#import "CallSheetDocument.h"
#import "WYPopoverController.h"
#import "SplashViewController.h"

@interface PPAppDelegate ()

- (void)loadDocuments;

@end

@implementation PPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//Refactor This for 1.4
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"Prepro launched.");
    
    [self loadDocuments];
    
    [[PPAppStyleManager sharedInstance] setCurrentStyleWithName: @"Blue"];
    
    //Move into settings default JSON
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        @"pressAndHoldToRearrange": @YES,
        @"pinchPullToCreateGesture": @YES
    }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ProjectManagerViewController *projectManagerViewController = [[ProjectManagerViewController alloc] init];
    
    self.navigationController = [[RootNavigationViewController alloc] initWithRootViewController:projectManagerViewController];
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    SplashViewController *splashViewController = [[SplashViewController alloc] init];
    [self.window addSubview:splashViewController.view];
    
    [self setupStyle];
    
    [Crittercism enableWithAppID: @"530ba0ec7c376442a2000003"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. - True True Fix in 1.4
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)setupStyle
{
    PPAppStyle * appStyle = [[PPAppStyleManager sharedInstance] appStyle];
    
    self.window.tintColor = [UIColor blackColor];
    
    [[UINavigationBar appearanceWhenContainedIn:[WYPopoverBackgroundView class], nil] setTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[WYPopoverBackgroundView class], nil] setTitleTextAttributes:@{
                                                                                                                             UITextAttributeTextColor: [UIColor whiteColor],
                                                                                                                             UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                                                                                                             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]
                                                                                                                             }];
    [[UINavigationBar appearance] setTintColor: appStyle.primaryColour];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [UIColor blackColor],
                                                           UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]
                                                           }];
    
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    
    
    [[WYPopoverBackgroundView appearance] setFillTopColor:[UIColor colorWithRed:0.216 green:0.247 blue:0.278 alpha:1.0]];
    [[WYPopoverBackgroundView appearance] setFillBottomColor:[UIColor colorWithRed:0.231 green:0.263 blue:0.298 alpha:1.0]];
    [[WYPopoverBackgroundView appearance] setInnerStrokeColor:[UIColor clearColor]];
    [[WYPopoverBackgroundView appearance] setInnerShadowColor:[UIColor clearColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Prepro" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Prepro.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if ( ![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: options error:&error] ) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Implementation

- (void)loadDocuments {
    
    _documents =  @[
                    [ProposalDocument alloc],
                    [ScriptDocument alloc],
                    [CharacterProfilesDocument alloc],
                    [ShotListDocument alloc],
                    [EquipmentListDocument alloc],
                    [CastDocument alloc],
                    [CrewDocument alloc],
                    [LocationListDocument alloc],
                    [PropListDocument alloc],
                    [NotesDocument alloc],
                    [RiskAssessmentDocument alloc],
                    [BudgetDocument alloc],
                    [ContingencyPlansDocument alloc],
                    [ShootingDatesDocument alloc],
                    [CallSheetDocument alloc]
                    //[StoryboardDocument alloc],
                    //[SoundtrackDocument alloc],
                    //[LogBookDocument alloc]
                    ];
    
}

@end
