//
//  NSManagedObject+Serialization.h
//  Prepro
//
//  Created by James Campbell on 30/09/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Serialization)

- (NSDictionary*) toDictionary;

- (void) populateFromDictionary:(NSDictionary*)dict;

+ (NSManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict
                                             inContext:(NSManagedObjectContext*)context;

@end
