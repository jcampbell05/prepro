//
//  PropListDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PropListDocument.h"
#import "NSObject+AppDelegate.h"
#import "TDBadgedCell.h"
#import "Prop.h"

@implementation PropListDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"props"];
}

- (NSString *)single {
    return @"Prop";
}

- (NSString *)plural{
    return @"Props";
}

- (NSString *)projectRelationshipKeyName {
    return @"props";
}

- (Class)entityClass {
    return [Prop class];
}

- (NSString *)titleForEntity:(id)entity {
    Prop *prop = (Prop *)entity;
    return prop.name;
}

- (Class)entityRowClass {
    return [TDBadgedCell class];
}

- (void)updateRow:(TDBadgedCell *)cell ForEntity:(id)entity {
    Prop *prop = (Prop *)entity;
    cell.textLabel.text = prop.name;
    cell.imageView.image = [UIImage imageWithData:prop.photo];
    
    if ([prop.quantity intValue] > 1) {
        cell.badgeString = [prop.quantity stringValue];
    }
}

@end
