//
//  PPHireViewController.h
//  Prepro
//
//  Created by James Campbell on 26/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "QuickDialogController.h"

@interface PPHireViewController : QuickDialogController

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) UIViewController * parentVC;

- (void)done;
- (void)close;

@end
