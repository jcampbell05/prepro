//
//  CharacterProfile.m
//  Prepro
//
//  Created by James Campbell on 16/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CharacterProfile.h"
#import "NSObject+AppDelegate.h"
#import "PPAppDelegate.h"

@implementation CharacterProfile

@dynamic age, background, build, characteristics, ethnicity, eyeColour, fears, gender, hairColour, hairLength, height, idNo, motives, name, notes, project, photo;

- (void)awakeFromInsert {
    self.name = @"New Character";
}

@end
