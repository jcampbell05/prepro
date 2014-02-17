//
//  PPScriptDialogueSection.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptDialogueSection.h"
#import "PPScriptCenteredTableViewCell.h"

@implementation PPScriptDialogueSection

- (Class)cellClass {
    return [PPScriptCenteredTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    cell.textLabel.text = self.text;
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = self.text;
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Dialogue";
}

- (void)processElementText:(NSString *)text {
    self.text = text;
}

@end
