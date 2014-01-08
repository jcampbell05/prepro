//
//  Project.h
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"
#import "Proposal.h"
#import "CharacterProfile.h"

@interface Project : Entity

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) Proposal *proposal;
@property (nonatomic, retain) NSSet *crew;
@property (nonatomic, retain) NSSet *cast;
@property (nonatomic, retain) NSSet *shots;
@property (nonatomic, retain) NSSet *characterProfiles;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) NSSet *props;
@property (nonatomic, retain) NSSet *equpiment;
@property (nonatomic, retain) NSSet *scripts;

@end
