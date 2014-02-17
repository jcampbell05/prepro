//
//  PPScriptSection.h
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Make advanced table view so we don't need to have all this scattered about

#import <UIKit/UIKit.h>
#import "FNElement.h"

@interface PPScriptSection : NSObject

- (NSString *)cellIdentifier;
- (Class)cellClass;
- (void)updateCell:(UITableViewCell *)cell;

- (FNElement *)scriptElement;
- (NSString *)elementType;
- (void)processElementText:(NSString *)text;

@end
