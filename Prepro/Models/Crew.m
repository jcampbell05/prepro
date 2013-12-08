//
//  Crew.m
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Crew.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"

@implementation Crew

@dynamic jobRole;
@dynamic name;
@dynamic department;
@dynamic project;
@dynamic photo;

- (void)awakeFromInsert {
    self.name = @"New Crew Member";
    self.department = @"Misc";
}

@end
