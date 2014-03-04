//
//  ProjectCollectionViewCell.m
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ProjectCollectionViewCell.h"


@implementation ProjectCollectionViewCell

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int height = CGRectGetHeight(self.bounds);
        int width = CGRectGetWidth(self.bounds);
        
        int thumbnailWidth = width - (ProjectCollectionViewCellMargin * 2);
        int thumbnailHeight = height - ( ProjectCollectionViewCellTitleTopMargin + ProjectCollectionViewCellTitleHeight + (ProjectCollectionViewCellMargin * 2) );
        
        UIImage *thumbnailImage = [UIImage imageNamed:@"ProjectThumbnail"];
        
        CGRect thumbnailFrame = CGRectMake(ProjectCollectionViewCellMargin, ProjectCollectionViewCellMargin, thumbnailWidth, thumbnailHeight);
        _thumbnail = [[UIImageView alloc] initWithFrame:thumbnailFrame];
        _thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbnail setImage:thumbnailImage];
        [self addSubview:_thumbnail];
        
        CGRect titleLabelFrame = CGRectMake(ProjectCollectionViewCellMargin, ProjectCollectionViewCellMargin + thumbnailFrame.size.height + ProjectCollectionViewCellTitleTopMargin, frame.size.width - (ProjectCollectionViewCellMargin * 2), ProjectCollectionViewCellTitleHeight );
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = _title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        CGRect tickImageViewFrame = CGRectMake(thumbnailWidth - (ProjectCollectionViewCellTickPadding +  ProjectCollectionViewCellTickSize), thumbnailHeight - (ProjectCollectionViewCellTickPadding +  ProjectCollectionViewCellTickSize), ProjectCollectionViewCellTickSize, ProjectCollectionViewCellTickSize);
        
        tickImageView = [[UIImageView alloc] initWithFrame:tickImageViewFrame];
        tickImageView.contentMode = UIViewContentModeScaleAspectFit;
        [tickImageView setImage:[UIImage imageNamed:@"DeleteTick.png"]];
        tickImageView.hidden = YES;
        [self addSubview:tickImageView];
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLabel.text = title;
    _title = title;
}

- (NSString *)title {
    return _title;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    tickImageView.hidden = !selected;
    
    if (selected) {
        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.layer.cornerRadius = 5.0f;
    }
    else {
        titleLabel.backgroundColor = [UIColor clearColor];
    }
}

@end
