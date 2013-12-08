//
//  DataEntityDefinition.h
//  Prepro
//
//  Created by James Campbell on 24/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKFormMapping.h"

@protocol DataEntityDefinition <NSObject>

@required;
@property (readonly) NSString *single;
@property (readonly) NSString *plural;
@property (readonly) NSString *dataEntityName;
@property (readonly) NSString *dataEntityProjectRelationshipKeyName;
@property (readonly) FKFormMapping *dataEntityFormMapping;

- (id)newDataEntity;
- (id)viewControllerForDataEntityEditing;

@optional
- (class)entityRowClass;
- (void)updateRow:(UITableViewCell *)cell ForEntityEntry:(id)entity;


@end
