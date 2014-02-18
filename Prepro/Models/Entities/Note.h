//
//  Note.h
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"

@class Project;

@interface Note : Entity

@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) Project *project;

@end
