//
//  PPScriptFormatMenuViewController.h
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPScriptFormatViewControllerDelegate.h"

@interface PPScriptFormatMenuViewController : UITableViewController {
    NSArray * _formatters;
}

@property (unsafe_unretained, atomic) id<PPScriptFormatViewControllerDelegate> delegate;

- (id)initWithFormatters:(NSArray *)formatters andDelegate:(id<PPScriptFormatViewControllerDelegate>) delegate;
- (void)dismiss;

@end
