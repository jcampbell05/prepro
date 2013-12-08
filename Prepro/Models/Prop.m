//
//  Prop.m
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Prop.h"


@implementation Prop

@dynamic name;
@dynamic quantity;
@dynamic price;
@dynamic supplier;
@dynamic notes;
@dynamic photo;

- (void)awakeFromInsert {
    self.name = @"New Prop";
    self.quantity = @(1);
}

@end
