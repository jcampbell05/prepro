//
//  PPExportTypeViewController.h
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// For v1.5

#import <UIKit/UIKit.h>
#import "PPExportDataSource.h"

@interface PPExportTypeViewController : UITableViewController {
    NSArray * _exportTypes;
}

@property (strong, atomic) id<PPExportDataSource> dataSource;

- (id)initWithDataSource:(id<PPExportDataSource>) dataSource;

@end
