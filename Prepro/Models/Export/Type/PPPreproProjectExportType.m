//
//  PPPreproProjectExportType.m
//  Prepro
//
//  Created by James Campbell on 21/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPPreproProjectExportType.h"
#import "NSManagedObject+Serialization.h"

@implementation PPPreproProjectExportType

- (NSString *)name {
    return @"Prepro Project";
}

- (NSString *)description {
    return @"Project file that can be imported into prepro.";
}

- (NSString *)extension {
    return @"prp";
}

- (NSData *)generateExportDataFromObject:(NSManagedObject *)object {
    return [NSKeyedArchiver archivedDataWithRootObject:[object toDictionary]];
}

@end
