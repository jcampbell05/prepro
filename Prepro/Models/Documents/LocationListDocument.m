//
//  LocationListDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "LocationListDocument.h"
#import "NSObject+AppDelegate.h"
#import "Location.h"

@implementation LocationListDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"locations"];
}

- (NSString *)single {
    return @"Location";
}

- (NSString *)plural {
    return @"Locations";
}

- (NSString *)projectRelationshipKeyName {
    return @"locations";
}

- (Class)entityClass {
    return [Location class];
}

- (NSString *)titleForEntity:(id)entity {
    Location *location = (Location *)entity;
    return location.name;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Location *location = (Location *)entity;
    cell.textLabel.text = location.name;
    cell.imageView.image = [UIImage imageWithData:location.photo];
}

@end
