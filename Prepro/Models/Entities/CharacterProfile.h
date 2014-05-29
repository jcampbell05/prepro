//
//  CharacterProfile.h
//  Prepro
//
//  Created by James Campbell on 16/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;
@interface CharacterProfile : Entity

@property (nonatomic, retain) NSNumber *age;
@property (nonatomic, retain) NSString *background;
@property (nonatomic, retain) NSString *build;
@property (nonatomic, retain) NSString *characteristics;
@property (nonatomic, retain) NSString *ethnicity;
@property (nonatomic, retain) NSString *eyeColour;
@property (nonatomic, retain) NSString *hairColour;
@property (nonatomic, retain) NSString *hairLength;
@property (nonatomic, retain) NSString *height;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *fears;
@property (nonatomic, retain) NSNumber *idNo;
@property (nonatomic, retain) NSString *motives;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSData *photo;
@property (nonatomic, retain) Project *project;

@end
