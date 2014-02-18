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

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Script *script = (Script *)entity;
    
    cell.textLabel.text = script.name;
}

- (NSString *)titleForEntity:(id)entity {
    Script *script = (Script *)entity;
    
    return script.name;
}

- (id)viewControllerForEditingEntity:(id)entity {
    
    PPScriptViewController * scriptViewController = [[PPScriptViewController alloc] init];
    scriptViewController.script = (Script *)entity;

    return scriptViewController;
}

@end
