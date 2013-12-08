//
//  Crew.h
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Crew : Entity

@property (nonatomic, retain) NSString * jobRole;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;

@end
