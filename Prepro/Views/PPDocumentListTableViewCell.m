//
//  PPDocumentListTableViewCell.m
//  Prepro
//
//  Created by James Campbell on 27/11/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPDocumentListTableViewCell.h"

@implementation PPDocumentListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.highlightedImage = [image negativeImage];
}

@end
