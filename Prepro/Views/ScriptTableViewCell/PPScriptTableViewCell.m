//
//  PPScriptTableViewCell.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptTableViewCell.h"

@implementation PPScriptTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font = [UIFont fontWithName:@"Courier" size:12];
        self.textLabel.textColor = [UIColor blackColor];
    }
    return self;
}

@end
