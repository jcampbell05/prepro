//
//  PPDocumentListTableViewCell.m
//  Prepro
//
//  Created by James Campbell on 27/11/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPDocumentListTableViewCell.h"
#import "DTCustomColoredAccessory.h"
#import "PPAppStyleManager.h"
#import "PPAppStyle.h"

@implementation PPDocumentListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        
        PPAppStyle * appStyle = [[PPAppStyleManager sharedInstance] appStyle];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.highlightedTextColor = appStyle.primaryColour;
        self.imageView.tintColor = appStyle.primaryColour;
        
        DTCustomColoredAccessory * accessory = [DTCustomColoredAccessory accessoryWithColor: self.textLabel.textColor];
        accessory.highlightedColor = appStyle.primaryColour;
        
        self.accessoryView = accessory;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView =bgColorView;
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.highlightedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
