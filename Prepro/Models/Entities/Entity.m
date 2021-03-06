
//
//  Entity.m
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Entity.h"
#import "Document.h"
#import "PPAppDelegate.h"
#import "NSObject+AppDelegate.h"

@implementation Entity

+ (id)createNew {
    
    NSString *className = NSStringFromClass([self class]);
    
    id entity = [NSEntityDescription insertNewObjectForEntityForName:className  inManagedObjectContext:[self managedObjectContext]];
    
    [entity setValue:[self currentProject] forKey:@"project"];
    
    NSError *error;
    if(![[self managedObjectContext] save:&error]){
        NSLog(@"Error creating %@.", className);
    } else {
        NSLog(@"%@ created.",className);
    }
    
    return entity;
}

//This seems a bit crufty
- (void)onSave:(Document *)document {
    
}

- (BOOL)save:(NSError **)error {
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    
    return [managedObjectContext save:error];
}

@end
