//
//  PPScriptSection.m
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Some of this code seems to be more with in the relm of the cell itself

#import "PPScriptSection.h"
#import "PPScriptTableViewCell.h"

@implementation PPScriptSection

- (NSString *)cellIdentifier {
    return nil;
}

- (Class)cellClass {
    return [PPScriptTableViewCell class];
}

- (void)updateCell:(UITableViewCell *)cell {

}

- (FNElement *)scriptElement {
    return nil;
}

- (NSString *)elementType {
    return nil;
}

- (void)processElementText:(NSString *)text {
    
}

@end
