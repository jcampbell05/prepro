//
//  PPScriptViewController.m
//  Prepro
//
//  Created by James Campbell on 07/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//


#import "PPScriptViewController.h"
#import "PPScriptVisualViewController.h"
#import "PPScriptPreviewViewController.h"
#import "PPScriptRawViewController.h"
#import "MBAlertView.h"

@interface PPScriptViewController ()

@end

@implementation PPScriptViewController

#pragma mark UIViewController Lifecycle

- (void)loadDocumentViews {
    PPDocumentView * previewView = [[PPDocumentView alloc] init];
    previewView.title = @"Preview";
    previewView.viewController = [[PPScriptPreviewViewController alloc] init];
    
    PPDocumentView * visualView = [[PPDocumentView alloc] init];
    visualView.title = @"Edit";
    visualView.viewController = [[PPScriptVisualViewController alloc] init];

    // TODO: 1.4 +
//    PPDocumentView * rawView = [[PPDocumentView alloc] init];
//    rawView.title = @"Raw";
//    rawView.viewController = [[PPScriptRawViewController alloc] init];
    
    self.views = @[
                   previewView
                   ,visualView
                  // ,rawView TODO: 1.4 +
                   ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( _script.content.length == 0 ) {
        [self setSelectedView: 1];
    }
    
    self.title = _script.name;
}

- (void)willSwitchToDocumentView:(PPDocumentView *)documentView {
    
    //Create way of not having to rely on this method, its kinda hacky
    [documentView.viewController setValue:_script forKey:@"script"];
    
}

- (void)save {
    _script.name =  self.title;

    NSError *error;
    if(![_script save:&error]){
        NSLog(@"Error saving script.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Script saved.");
    }
}

@end
