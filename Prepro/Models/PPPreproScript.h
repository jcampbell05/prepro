//
//  PPPreproScript.h
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNScript.h"

@interface PPPreproScript : NSObject

@property (strong, nonatomic) NSArray * formatters;
@property (strong, nonatomic) FNScript * script;

- (id)initWithScript:(FNScript *)script andFormatters:(NSArray *)formatters;

- (NSMutableArray *)sections;

@end
