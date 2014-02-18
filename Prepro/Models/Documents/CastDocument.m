//
//  CastAndCrewDocument.m
//  Prepro
//
//  Created by James Campbell on 25/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CastDocument.h"
#import "Cast.h"

@implementation CastDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"cast"];
}

- (NSString *)single {
    return @"Cast";
}

- (NSString *)projectRelationshipKeyName {
    return @"cast";
}

- (Class)entityClass {
    return [Cast class];
}

- (UITableViewCellStyle)entityRowStyle {
    return UITableViewCellStyleSubtitle;
}

- (NSString *)titleForEntity:(id)entity {
    Cast *castMember = (Cast *)entity;
    return castMember.name;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Cast *castMember = (Cast *)entity;
    cell.textLabel.text = castMember.characterName;
    cell.detailTextLabel.text = castMember.name;
    cell.imageView.image = [UIImage imageWithData:castMember.photo];
}

@end
