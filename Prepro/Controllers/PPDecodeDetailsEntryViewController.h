//
//  PPDecodeDetailsEntryViewController.h
//  Prepro
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Initially For Decode but will be for more in future

#import "QuickDialogController.h"

@interface PPDecodeDetailsEntryViewController : QuickDialogController

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) UIViewController * parentVC;

- (void)done;
- (void)close;

@end
