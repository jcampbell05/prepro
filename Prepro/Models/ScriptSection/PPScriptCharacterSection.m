//
//  PPScriptCharacterSection.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptCharacterSection.h"
#import "PPScriptCenteredTableViewCell.h"

@implementation PPScriptCharacterSection

- (Class)cellClass {
    return [PPScriptCenteredTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    cell.textLabel.text = [self.name uppercaseString];
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = [self.name uppercaseString];
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Character";
}

- (void)processElementText:(NSString *)text {
   self.name = text;
}

@end
