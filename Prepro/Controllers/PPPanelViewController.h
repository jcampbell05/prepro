//
//  PPPanelViewController.h
//  Prepro
//
//  Created by James Campbell on 01/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SLIDE_DURATION 0.3
#define PANEL_LEFT_GAP 55

@protocol PPPanelViewControllerDelegate;

@interface PPPanelViewController : UIViewController

@property (assign, atomic)  BOOL showingPanel;
@property (weak, atomic) id<PPPanelViewControllerDelegate> delegate;
@property (strong, atomic) UIViewController * rootViewController;
@property (strong, atomic) UIViewController * panelViewController;

- (id)initWithRootViewController:(UIViewController *)controller;

- (void)showPanelViewController:(UIViewController *)controller;
- (void)hidePanelViewController;

@end
