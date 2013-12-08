//
//  ProposalDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ProposalDocument.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"

@implementation ProposalDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"proposal"];
}

- (NSString *)single {
    return @"Proposal";
}

- (Class)entityClass {
    return [Proposal class];
}

- (UIViewController *)viewControllerForManaging {
    
    Proposal *proposal =  [NSObject currentProject].proposal;
    
   if (!proposal){
       proposal = [self newEntity];
       [NSObject currentProject].proposal = proposal;
   }
    
    return [self viewControllerForEditingEntity:proposal];
}

@end
