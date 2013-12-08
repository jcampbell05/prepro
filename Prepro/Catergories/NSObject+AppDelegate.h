//
//  NSObject+AppDelegate.h
//  Prepro
//
//  Created by James Campbell on 24/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Project.h"

@interface NSObject (AppDelegate)

//TODO: Move this class method to Project Class 
+ (Project *)currentProject;
+ (NSManagedObjectContext *)managedObjectContext;

@end
