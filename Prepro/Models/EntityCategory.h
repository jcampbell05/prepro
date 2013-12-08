//
//  EntityCategory.h
//  Prepro
//
//  Created by James Campbell on 22/09/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSArray * (^EntityCategoryUpdateEntitiesBlock) (NSArray *);

typedef BOOL (^EntityCategoryCanBlock) (int);

typedef void (^EntityCategoryCellBlock) ();
typedef id (^EntityCategoryAddBlock) (int);
typedef id (^EntityCategoryMoveToBlock) (int, id);
typedef id (^EntityCategoryMoveFromBlock) (int, id);

@interface EntityCategory : NSObject

@property (copy, readonly) NSMutableArray *entities;
@property (strong, atomic) NSString *title;

@property (copy) EntityCategoryUpdateEntitiesBlock updateEntitiesBlock;

@property (copy) EntityCategoryCanBlock canAddBlock;
@property (copy) EntityCategoryCanBlock canMoveBlock;

@property (copy) EntityCategoryMoveToBlock moveToBlock;
@property (copy) EntityCategoryMoveFromBlock moveFromBlock;
@property (copy) EntityCategoryAddBlock addBlock;

- (void)updateEntities:(NSArray *) entities;

- (BOOL)canAddEntityAtIndex:(int) index;
- (BOOL)canMoveEntityAtIndex:(int) index;

- (void)addEntityAtIndex:(int) index;
- (void)moveEntity:(id)entity toIndex:(int) index;
- (id)moveEntityFromIndex:(int) index;

- (void)removeEntitiyFromIndex:(int) index;

@end
