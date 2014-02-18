//
//  PPScriptCenteredTableViewCell.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptCenteredTableViewCell.h"

@implementation PPScriptCenteredTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, self.textLabel.frame.origin.y, self.frame.size.width, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(0, self.detailTextLabel.frame.origin.y, self.frame.size.width, self.detailTextLabel.frame.size.height);
}

@end
