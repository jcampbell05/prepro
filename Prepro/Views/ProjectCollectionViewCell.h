//
//  ProjectCollectionViewCell.h
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define ProjectCollectionViewCellTitleHeight 20
#define ProjectCollectionViewCellTitleTopMargin 5
#define ProjectCollectionViewCellMargin 5
#define ProjectCollectionViewCellTickPadding 0
#define ProjectCollectionViewCellTickSize 32

@interface ProjectCollectionViewCell : UICollectionViewCell {
    UILabel *titleOverlay;
    UILabel *titleLabel;
    UIImageView *tickImageView;
}

@property (strong) UIImageView *thumbnail;
@property (strong) NSString *title;

@end
