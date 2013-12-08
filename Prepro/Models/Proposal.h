//
//  Proposal.h
//  Prepro
//
//  Created by James Campbell on 27/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Proposal : Entity

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *format;
@property (nonatomic, retain) NSString *synopsis;
@property (nonatomic, retain) NSString *style;
@property (nonatomic, retain) NSString *structure;
@property (nonatomic, retain) NSString *audience;
@property (nonatomic, retain) Project *project;

@end
