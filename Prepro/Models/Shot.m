//
//  Shot.m
//  Prepro
//
//  Created by James Campbell on 02/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Shot.h"
#import "Document.h"
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
@dynamic angle;
@dynamic transition;

- (void)awakeFromInsert {
    self.title = @"New Shot";
    self.locationType = @"INT";
    self.transition = @"Cut";
}


//TODO: Make a better way of doing, maybe make the models more magical with ORM ? Look for library for this or roll your own maybe ? 
- (void)onSave:(Document *)document {
    
    NSSet *shots = (NSSet *)[self.project valueForKey:[document projectRelationshipKeyName]];

    if ([self.number intValue] < 1) {
        self.number = @1;
    } else if ([shots count] < [self.number intValue]) {
        self.number = @([shots count]);
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectID != %@", self.objectID];
    
    NSMutableArray * filteredShots = [[[shots filteredSetUsingPredicate:predicate] allObjects] mutableCopy];
    [filteredShots insertObject:self atIndex:[self.number integerValue] - 1];
    
    [filteredShots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Shot * shot, NSUInteger idx, BOOL *stop) {
        shot.number = @(idx + 1);
    }];
    
    [self.project setValue:[NSSet setWithArray:filteredShots] forKey:[document projectRelationshipKeyName]];
}

@end
