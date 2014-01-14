//
//  PPScriptSectionTypeSelectorViewController.h
//  Prepro
//
//  Created by James Campbell on 14/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScriptSectionTypeSelectorCancelBlock)();

@interface PPScriptSectionTypeSelectorViewController : UITableViewController

@property (copy, nonatomic) ScriptSectionTypeSelectorCancelBlock cancelBlock;

- (void)cancelPressed;

@end
