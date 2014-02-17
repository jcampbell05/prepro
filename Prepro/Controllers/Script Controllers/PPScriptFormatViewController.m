//
//  PPScriptFormatViewController.m
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptFormatViewController.h"
#import "PPScriptFormatEntryViewController.h"
#import "PPScriptFormatter.h"

@interface PPScriptFormatViewController ()

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end

@implementation PPScriptFormatViewController

#pragma mark UIViewController Lifecycle

- (id)initWithFormatters:(NSArray *)formatters andDelegate:(id<PPScriptFormatViewControllerDelegate>) delegate {
    
    if ( self = [super init] ) {
        
        _formatters = formatters;
        _delegate = delegate;
        self.view.frame = CGRectMake(0, 0, 320, 200);
    }
    
    return self;
}

- (void)viewDidLoad {

    //TODO: Stop this hacky way of passing the delegate around
    
    _formatMenuViewController = [[PPScriptFormatMenuViewController alloc] initWithFormatters: _formatters andDelegate:_delegate];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController: _formatMenuViewController];
    
    [self addChildViewController: _navigationController];
    [self.view addSubview: _navigationController.view];
}

- (void)addScriptSection {
    [_navigationController popToRootViewControllerAnimated: NO];
}

- (void)editScriptSection:(PPScriptSection *)section {
    [_navigationController popToRootViewControllerAnimated: NO];
    
    __block PPScriptFormatter * formatter;
    
    [_formatters enumerateObjectsUsingBlock:^(PPScriptFormatter * obj, NSUInteger idx, BOOL *stop) {
        
        if ( [[obj scriptSectionForFormat] class] == [section class] ) {
            
            formatter = obj;
            *stop = YES;
        }
        
    }];
    
    QRootElement * root = formatter.visualEditForm;
    [root bindToObject: section];
    
    PPScriptFormatEntryViewController * quickDialogController = [PPScriptFormatEntryViewController controllerForRoot: root];
    
    quickDialogController.delegate = _delegate;
    quickDialogController.formatter = formatter;
    quickDialogController.section = section;
    
    [_navigationController pushViewController: quickDialogController animated: NO];
}

@end
