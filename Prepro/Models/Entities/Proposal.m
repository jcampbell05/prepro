//
//  Proposal.m
//  Prepro
//
//  Created by James Campbell on 27/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Proposal.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"


@implementation Proposal

@dynamic genre;
@dynamic duration;
@dynamic fps;
@dynamic aspectRatio;
@dynamic format;
@dynamic synopsis;
@dynamic style;
@dynamic structure;
@dynamic audience;
@dynamic project;

- (NSString *)title {
    return [NSObject currentProject].title;
}

- (void)setTitle:(NSString *)title {
    [NSObject currentProject].title = title;
}


+ (id)createNew {
    
    Proposal *proposal  = (Proposal *)[NSEntityDescription insertNewObjectForEntityForName:@"Proposal" inManagedObjectContext:[self managedObjectContext]];
    
    proposal.project = [self currentProject];
    
    NSError *error;
    if(![[self managedObjectContext] save:&error]){
        NSLog(@"Error creating Proposal.");
    } else {
        NSLog(@"Proposal created.");
    }
    
    return proposal ;
}

@end
