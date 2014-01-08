//
//  ScriptDocument.m
//  Prepro
//
//  Created by James Campbell on 02/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "ScriptDocument.h"
#import "Script.h"

#import "PPScriptViewController.h"

@implementation ScriptDocument

- (UIImage *)icon {
    return [UIImage imageNamed:@"script"];
}

- (NSString *)single {
    return @"Script";
}

- (NSString *)plural {
    return @"Scripts";
}

- (Class) entityClass {
    return [Script class];
}

- (NSString *)projectRelationshipKeyName {
    return @"scripts";
}

- (id)viewControllerForEditingEntity:(id)entity {
    
    return [[PPScriptViewController alloc] init];
}

@end
