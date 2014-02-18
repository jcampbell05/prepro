//
//  PPScriptPreviewViewController.h
//  Prepro
//
//  Created by James Campbell on 05/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"

@interface PPScriptPreviewViewController : UIViewController {
    UIWebView * _webView;
}

@property (strong, nonatomic) Script * script;

@end
