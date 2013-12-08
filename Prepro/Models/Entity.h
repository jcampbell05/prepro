//
//  Entity.h
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Add Other Methods to make managing entities easier for things like removing / moving

#import <CoreData/CoreData.h>
#import "NSManagedObject+Serialization.h"

@class Document;
@interface Entity : NSManagedObject <NSCoding>

+ (id)createNew;
- (void)onSave:(Document *)document;

@end
