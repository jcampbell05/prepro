//
//  PPExportType.m
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPExportType.h"

@implementation PPExportType

- (NSString *)name {
    return @"Export Type";
}

- (NSString *)description {
    return @"For exporting documents";
}

- (NSString *)mimeType {
    return @"text/plain";
}

- (NSString *)extension {
    return @"txt";
}

- (NSData *)generateExportDataFromObject:(id)object {
    return nil;
}

@end
