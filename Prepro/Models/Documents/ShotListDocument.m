//
//  ShotListDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ShotListDocument.h"
#import "EntityCategory.h"
#import "EntityManagerViewController.h"
#import "Shot.h"
#import "NSObject+AppDelegate.h"

@implementation ShotListDocument

- (id)newEntity {
    Shot * shot = (Shot *)[super newEntity];
    shot.number = @([[NSObject currentProject].shots count]);
    
    return shot;
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"Shots"];
}

- (NSString *)single {
    return @"Shot";
}

- (NSString *)plural {
    return @"Shots";
}

- (NSString *)projectRelationshipKeyName {
    return @"shots";
}

- (Class)entityClass {
    return [Shot class];
}

- (bool)entityBatchCreationAllowed {
    return YES;
}

- (NSString *)titleForEntity:(id)entity {
    Shot *shot = (Shot *)entity;
    return shot.title;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Shot *shot = (Shot *)entity;
    cell.textLabel.text = shot.title;
    cell.imageView.image = [UIImage imageWithData:shot.photo];
}

#pragma mark Entity Category

- (void)loadDefaultEntityCategory {
    
    [super loadDefaultEntityCategory];
    
    self.defaultEntityCategory.updateEntitiesBlock = ^ (NSArray * entities) {
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self.number" ascending: YES];
        
        return [entities sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    };
    
    self.defaultEntityCategory.canAddBlock = ^ (int index) {
        return YES;
    };
    
    self.defaultEntityCategory.canMoveBlock = ^ (int index) {
        return YES;
    };
    
    self.defaultEntityCategory.addBlock = ^ (int index) {
        
        Shot *newShot = [self newEntity];
        
        return newShot;
    };
    
    self.defaultEntityCategory.moveToBlock = ^ (int index, id entity) {
        
        [self.defaultEntityCategory.entities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((Shot *)obj).number = @(idx + 1);
        }];
        
        return entity;
    };
    
}

@end
