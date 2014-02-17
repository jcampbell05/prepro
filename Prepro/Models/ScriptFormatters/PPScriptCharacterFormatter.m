//
//  PPScriptCharacterFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptCharacterFormatter.h"
#import "PPScriptCharacterSection.h"

@implementation PPScriptCharacterFormatter

- (QRootElement *)visualEditForm {
    
    QRootElement * rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Character";
    
    QSection * defaultSection = [[QSection alloc] initWithTitle:nil];
    
    QEntryElement * characterName = [[QEntryElement alloc] initWithKey:@"name"];
    characterName.title = @"Name";
    characterName.bind = @"textValue:name";
    
    [defaultSection addElement: characterName];
    
    [rootElement addSection: defaultSection];
    
    return rootElement;
}

- (PPScriptSection *)scriptSectionForFormat {
    return [[PPScriptCharacterSection alloc] init];
}

- (NSString *)title {
    return @"Character";
}

@end
