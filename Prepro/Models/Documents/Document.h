//
//  Document.h
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Refactor and simplify as well as make more automated, way for it to control individual documents. Break into sub-classes or sub protocols ?

// This document and entity system doesn't really work, figure out something better !

#import <Foundation/Foundation.h>

@class EntityCategory;

@interface Document : NSObject {
    NSArray *entityCategories;
}

@property (readonly) UIImage * icon;
@property (readonly) NSString * single;
@property (readonly) NSString * plural;
@property (readonly) NSString * projectRelationshipKeyName;
@property (strong, nonatomic) NSArray * entityCategories;
@property (strong, nonatomic) EntityCategory * defaultEntityCategory;


//This is quickly getting ugly - Needs Tidy up :)
- (bool)comingSoon;
- (bool)decodeEnabled; //<--- We will replace this soon with a generic hire system

- (UIViewController *)viewControllerForManaging;
- (Class)entityClass;
- (id)newEntity;
- (NSString *)titleForEntity:(id)entity;
- (Class)entityRowClass;
- (bool)entityBatchCreationAllowed;
- (UITableViewCellStyle)entityRowStyle;
- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity;
- (void)updateRowWithPlaceholder:(UITableViewCell *)cell;
- (id)viewControllerForEditingEntity:(id)entity;

#pragma mark Entity Category

- (void)loadDefaultEntityCategory;
- (void)loadEntityCategories;

#pragma mark - Deprecated
- (id)bindingData DEPRECATED_MSG_ATTRIBUTE("Deprecated in 1.4.1");

@end
