//
//  Cast.m
//  Prepro
//
//  Created by James Campbell on 02/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Cast.h"
#import "CharacterProfile.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"

@implementation Cast

@dynamic name;
@dynamic characterName;
@dynamic mobile;
@dynamic email;
@dynamic photo;
@dynamic project;
@dynamic character;

- (void)awakeFromInsert {
    self.name = @"New Cast Member";
}

@end
