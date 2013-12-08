//
//  Document.h
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Refactor and simplify as well as make more automated

#import <Foundation/Foundation.h>
#import "EntityCategory.h"

@interface Document : NSObject {
    NSArray *entityCategories;
}

@property (readonly) UIImage *icon;
@property (readonly) NSString *single;
@property (readonly) NSString *plural;
@property (readonly) NSString *projectRelationshipKeyName;
@property (readonly) NSArray *entityCategories;

- (bool)comingSoon;
- (EntityCategory *)defaultCategory;
- (NSArray *)loadEntityCategories;
- (UIViewController *)viewControllerForManaging;
- (Class)entityClass;
- (id)newEntity;
- (NSString *)titleForEntity:(id)entity;
- (Class)entityRowClass;
- (bool)entityBatchCreationAllowed;
- (UITableViewCellStyle)entityRowStyle;
- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity;
- (void)updateRowWithPlaceholder:(UITableViewCell *)cell;
- (id)bindingData;
- (id)viewControllerForEditingEntity:(id)entity;

@end
