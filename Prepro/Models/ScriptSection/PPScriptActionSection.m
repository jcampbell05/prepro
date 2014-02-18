//
//  PPScriptActionSection.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptActionSection.h"

@implementation PPScriptActionSection

- (NSString *)cellIdentifier {
    return @"action";
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
    return @"Action";
}

- (void)processElementText:(NSString *)text {
    self.text = text;
}

@end
