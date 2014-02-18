//
//  Note.m
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Note.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"

@implementation Note

@dynamic contents;
@dynamic created;
@dynamic project;

- (void)awakeFromInsert {
    self.created = [NSDate date];
}

@end
