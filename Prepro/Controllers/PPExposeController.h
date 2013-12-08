//
//  PPExposeController.h
//  Prepro
//
//  Created by James Campbell on 18/11/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIExposeController.h"
#import "PPNavigationViewController.h"

@class ProjectManagerViewController;

@interface PPExposeController: LIExposeController<LIExposeControllerDelegate, LIExposeControllerChildViewControllerDelegate, LIExposeControllerDataSource>

@property (strong, nonatomic) ProjectManagerViewController * projectManagerViewController;

- (id)initWithProjectManager:(ProjectManagerViewController *)manager;

- (UIViewController *)makeNewProjectView;

@end
