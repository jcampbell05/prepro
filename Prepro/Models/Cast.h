//
//  Cast.h
//  Prepro
//
//  Created by James Campbell on 02/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class CharacterProfile, Project;

@interface Cast : Entity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * characterName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) CharacterProfile *character;

@end
