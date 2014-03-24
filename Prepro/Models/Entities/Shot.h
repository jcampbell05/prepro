//
//  Shot.h
//  Prepro
//
//  Created by James Campbell on 02/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Shot : Entity

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * locationType;
@property (nonatomic, retain) NSString * angle;
@property (nonatomic, retain) NSString * transition;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;

@end
