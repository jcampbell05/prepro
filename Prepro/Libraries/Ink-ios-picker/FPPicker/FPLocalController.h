//
//  FPLocalController.h
//  FPPicker
//
//  Created by Liyan David Chang on 6/20/12.
//  Copyright (c) 2012 Filepicker.io (Cloudtop Inc), All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FPPicker.h"
#import "FPInternalHeaders.h"
#import "FPTableWithUploadButtonViewController.h"

@interface FPLocalController : FPTableWithUploadButtonViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) id <FPSourcePickerDelegate> fpdelegate;
@property (nonatomic, retain) ALAssetsGroup *assetGroup;

@end
