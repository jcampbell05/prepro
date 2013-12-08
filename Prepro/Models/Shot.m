//
//  Shot.m
//  Prepro
//
//  Created by James Campbell on 02/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Shot.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"

@implementation Shot

@dynamic number;
@dynamic title;
@dynamic type;
@dynamic duration;
@dynamic descriptionText;
@dynamic locationType;
@dynamic project;
@dynamic photo;

- (void)awakeFromInsert {
    self.title = @"New Shot";
    self.locationType = @"INT";
}

@end
