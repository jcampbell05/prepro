//
//  PPScriptSceneFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptSceneFormatter.h"
#import "PPScriptSceneSection.h"

@implementation PPScriptSceneFormatter

- (QRootElement *)visualEditForm {
    
    QRootElement * rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Scene";
    
    QSection * defaultSection = [[QSection alloc] initWithTitle:nil];
    
    QRadioElement * sceneType = [[QRadioElement alloc] initWithItems:@[@"INT", @"EXT", @"EST", @"INT/EXT", @"EXT/INT"] selected:1];
    sceneType.key = @"type";
    sceneType.title = @"Type";
    sceneType.bind = @"selectedItem:type";
    
    QEntryElement * sceneTitle = [[QEntryElement alloc] initWithKey:@"title"];
    sceneTitle.title = @"Title";
    sceneTitle.bind = @"textValue:title";
    
    [defaultSection addElement: sceneType];
    [defaultSection addElement: sceneTitle];
    
    [rootElement addSection: defaultSection];
    
    return rootElement;
}

- (PPScriptSection *)scriptSectionForFormat {
    return [[PPScriptSceneSection alloc] init];
}

- (NSString *)title {
    return @"Scene";
}

@end
