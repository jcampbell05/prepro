//
//  Project.m
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Project.h"
#import "PPAppDelegate.h"

@implementation Project

@dynamic title, proposal, characterProfiles, notes, crew, cast, shots, locations, props, equpiment;

+ (id)createNew {
    
    //TODO: Shortcut for this
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication]. delegate managedObjectContext];
    
    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    project.title = @"New Project";
    
    NSError *error;
    if(![managedObjectContext save:&error]){
         NSLog(@"Error creating project.");
    } else {
        NSLog(@"New project created.");
    }
    
    return project;
}

@end
