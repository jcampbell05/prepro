//
//  Location.m
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Location.h"


@implementation Location

@dynamic name;
@dynamic type;
@dynamic addressLine1;
@dynamic addressLine2;
@dynamic addressLine3;
@dynamic addressLine4;
@dynamic addressLine5;
@dynamic contactName;
@dynamic email;
@dynamic phone;
@dynamic notes;
@dynamic photo;

- (void)awakeFromInsert {
    self.name = @"New Location";
    self.type = @"INT";
}

@end
