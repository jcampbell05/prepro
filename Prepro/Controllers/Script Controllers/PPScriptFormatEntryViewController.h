//
//  PPScriptFormatEntryViewController.h
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Remove the need for the edit flag.

#import "QuickDialogController.h"
#import "PPScriptFormatViewControllerDelegate.h"
#import "PPScriptFormatter.h"

@interface PPScriptFormatEntryViewController : QuickDialogController

@property (unsafe_unretained, atomic) id<PPScriptFormatViewControllerDelegate> delegate;
@property (strong, nonatomic) PPScriptSection * section;
@property (strong, nonatomic) PPScriptFormatter * formatter;

+ (PPScriptFormatEntryViewController *)controllerForRoot:(QRootElement *)root;
- (void)add;

@end
