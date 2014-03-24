//
//  PPProductViewController.h
//  Prepro
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Equipment;

@interface PPProductViewController : UITableViewController

@property (strong, nonatomic) QuickDialogTableView * quickTableView;
@property (strong, nonatomic) Equipment * equipment;

- (id)initWithEquipment:(Equipment *)equipment;

@end
