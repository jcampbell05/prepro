//
//  Prop.h
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Prop : Entity

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * supplier;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;

@end
