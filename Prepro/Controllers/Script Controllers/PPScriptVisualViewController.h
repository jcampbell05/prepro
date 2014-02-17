//
//  PPScriptVisualViewController.h
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "PPTextView.h"
#import "PPScriptFormatViewController.h"
#import "PPScriptFormatViewControllerDelegate.h"
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"

@interface PPScriptVisualViewController : UITableViewController<PPScriptFormatViewControllerDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate> {
    
    NSIndexPath * placeholderIndexPath;
    
    NSMutableArray * _sections;
    NSArray * _formatters;
    
    //TODO: Remove this - Saves memory - make this constructed when needed
    PPScriptFormatViewController * _formatViewController;
}

@property (nonatomic, strong) JTTableViewGestureRecognizer * tableViewRecognizer;
@property (strong, nonatomic) Script * script;

@end
