//
//  Equipment.m
//  Prepro
//
//  Created by James Campbell on 03/06/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Equipment.h"
#import "Project.h"


@implementation Equipment

@dynamic quantity;
@dynamic name;
@dynamic supplier;
@dynamic price;
@dynamic priceRate;
@dynamic notes;
@dynamic type;
@dynamic product;
@dynamic photo;
@dynamic project;

- (void)awakeFromInsert {
    self.name = @"New Equipment";
    self.type = @"Misc";
    self.quantity = @(1);
}

@end
