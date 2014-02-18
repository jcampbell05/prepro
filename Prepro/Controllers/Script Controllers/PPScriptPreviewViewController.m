//
//  PPScriptPreviewViewController.m
//  Prepro
//
//  Created by James Campbell on 05/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptPreviewViewController.h"
#import "FNScript.h"
#import "FNHTMLScript.h"

@interface PPScriptPreviewViewController ()

@end

@implementation PPScriptPreviewViewController

#pragma mark UIViewController Lifecycle

- (void)loadView {
    _webView = [[UIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    
    self.view = _webView;
}

- (void)viewWillAppear:(BOOL)animated {

    FNScript *script = [[FNScript alloc] initWithString:_script.content];
    FNHTMLScript *htmlScript = [[FNHTMLScript alloc] initWithScript:script];
    
    [_webView loadHTMLString:[htmlScript html] baseURL:nil];
}

@end
