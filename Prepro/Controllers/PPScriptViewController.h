//
//  PPScriptViewController.h
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Refactor and Breakdown further, create view managment system in superclass ?

#import <UIKit/UIKit.h>
#import "PPDocumentViewController.h"
#import "Script.h"


@interface PPScriptViewController : PPDocumentViewController

@property (strong, atomic) Script * script;

- (void)save;

@end
