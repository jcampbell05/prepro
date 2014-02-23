//
//  CharacterProfilesDocument.m
//  Prepro
//
//  Created by James Campbell on 25/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CharacterProfilesDocument.h"
#import "EntityManagerViewController.h"
#import "CharacterProfile.h"

@implementation CharacterProfilesDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Characters"];
}

- (NSString *)single {
    return @"Character";
}

- (NSString *)plural {
    return @"Characters";
}

- (NSString *)projectRelationshipKeyName {
    return @"characterProfiles";
}

- (Class)entityClass {
    return [CharacterProfile class];
}

- (NSString *)titleForEntity:(id)entity {
    CharacterProfile *characterProfile = (CharacterProfile *)entity;
    return characterProfile.name;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    CharacterProfile *characterProfile = (CharacterProfile *)entity;
    cell.textLabel.text = characterProfile.name;
    cell.imageView.image = [UIImage imageWithData:characterProfile.photo];
}

@end
