//
//  UIViewController+PPPanel.m
//  Prepro
//
//  Created by James Campbell on 01/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "UIViewController+PPPanel.h"
#import <objc/runtime.h>

@implementation UIViewController (PPPanel)

NSString const * kPanelController = @"panelController";

- (PPPanelViewController *)panelController {
    return (PPPanelViewController *)objc_getAssociatedObject(self, (__bridge const void *)(kPanelController));
}

- (void)setPanelController:(PPPanelViewController *)panelController {
    objc_setAssociatedObject(self, (__bridge const void *)(kPanelController), panelController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
