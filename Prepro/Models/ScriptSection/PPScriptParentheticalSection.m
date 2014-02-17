//
//  PPScriptParentheticalSection.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptParentheticalSection.h"
#import "PPScriptCenteredTableViewCell.h"

@implementation PPScriptParentheticalSection

- (Class)cellClass {
    return [PPScriptCenteredTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {
    cell.textLabel.text = [NSString stringWithFormat:@"(%@)", self.text];
}

- (FNElement *)scriptElement {
    
    FNElement * element = [[FNElement alloc] init];
    
    element.elementText = [NSString stringWithFormat:@"(%@)", self.text];
    element.elementType = [self elementType];
    
    return element;
}

- (NSString *)elementType {
    return @"Parenthetical";
}

- (void)processElementText:(NSString *)text {
    self.text = text;
}

@end
