//
//  PPExportType.h
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPExportType : NSObject

- (NSString *)name;
- (NSString *)description;
- (NSString *)mimeType;
- (NSString *)extension;
- (NSData *)generateExportDataFromObject:(id)object;

@end
