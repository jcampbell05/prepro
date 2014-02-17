//
//  PPScriptSceneSection.m
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: A bit of duplication here

#import "PPScriptSceneSection.h"
#import "PPScriptSceneTableViewCell.h"

@implementation PPScriptSceneSection

- (NSString *)cellIdentifier {
    return @"scene";
}

- (Class)cellClass {
    return [PPScriptSceneTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    
    //TODO: Create Prepro Macro to handle some of this
    cell.textLabel.text = [[NSString stringWithFormat:@"%@. %@", (self.type) ? self.type : @"", self.title] uppercaseString];
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = [[NSString stringWithFormat:@"%@. %@", (self.type) ? self.type : @"", self.title] uppercaseString];
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Scene Heading";
}

- (void)processElementText:(NSString *)text {
    self.title = text;
}

@end
