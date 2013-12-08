//
//  NSObject+AppDelegate.m
//  Prepro
//
//  Created by James Campbell on 24/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "NSObject+AppDelegate.h"
#import "PPAppDelegate.h"

@implementation NSObject (AppDelegate)

+ (Project *)currentProject {
    PPAppDelegate *appDelegate = (PPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.currentProject;
}

+ (NSManagedObjectContext *)managedObjectContext {
   return [(PPAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}

@end
