//
//  PPScriptFormatEntryViewController.m
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptFormatEntryViewController.h"
#import "PPScriptSection.h"

@interface PPScriptFormatEntryViewController ()

@end

@implementation PPScriptFormatEntryViewController

#pragma mark UIViewController Lifecycle

+ (PPScriptFormatEntryViewController *)controllerForRoot:(QRootElement *)root {
    
    PPScriptFormatEntryViewController * controller = [[PPScriptFormatEntryViewController alloc] initWithRoot: root];
    
    return controller;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //TODO: Reduce Code here
    if ( _section ) {
        
        //Hack to hide back button
        [self.navigationItem setHidesBackButton: YES];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
        
    } else {
        
        //Hack to unhide back button
        [self.navigationItem setHidesBackButton: NO];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    }
    
}

#pragma mark Implementation

//TODO: Add is a bad name for this
- (void)add {
    
    //TODO: Reduce Code here
    if ( _section ) {
        
        [self.root fetchValueIntoObject: _section];
        
        if ( [_delegate respondsToSelector:@selector(scriptFormatSectionEdited:)] ) {
            [_delegate scriptFormatSectionEdited: _section];
        }
        
    } else {
        
        PPScriptSection * newSection = [_formatter scriptSectionForFormat];
        
        [self.root fetchValueIntoObject: newSection];
        
        if ( [_delegate respondsToSelector:@selector(scriptFormatSectionAdded:)] ) {
            [_delegate scriptFormatSectionAdded: newSection];
        }
        
    }
    
     NSLog(@"dis");
    
    [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion: nil];
}

@end
