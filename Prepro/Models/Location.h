//
//  Location.h
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Location : Entity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * addressLine3;
@property (nonatomic, retain) NSString * addressLine4;
@property (nonatomic, retain) NSString * addressLine5;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;

@end
