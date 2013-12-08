//
//  PPPanelViewControllerDelegate.h
//  Prepro
//
//  Created by James Campbell on 01/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPPanelViewControllerDelegate <NSObject>

- (void)panelDidHide;
- (void)panelDidShow;
- (void)panelWillHide;
- (void)panelWillShow;
- (void)panelDidSwap;

@end
