//
//  PPNavigationViewController.m
//  Prepro
//
//  Created by James Campbell on 05/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPNavigationViewController.h"

@interface PPNavigationViewController ()

@end

@implementation PPNavigationViewController

- (BOOL)shouldAutomaticallyForwardRotationMethods{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Nav child viewcs %@", self.childViewControllers.debugDescription);
}

@end
