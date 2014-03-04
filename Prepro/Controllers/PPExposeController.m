//
//  PPExposeControllerm
//  Prepro
//
//  Created by James Campbell on 18/11/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPExposeController.h"
#import "PPPanelViewController.h"
#import "ProjectViewController.h"
#import "PPNavigationViewController.h"

@interface PPExposeController ()

@end

@implementation PPExposeController

- (id)initWithProjectManager:(ProjectManagerViewController *)manager {
    if (self = [super init]) {
        _projectManagerViewController = manager;
        
        [self setExposeDelegate:self];
        [self setExposeDataSource:self];
        [self setViewControllers:[@[[self makeNewProjectView]] mutableCopy]];
    }
    
    return self;
}

- (UIView *)backgroundViewForExposeController:(LIExposeController *)exposeController {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                          0,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height)];
    v.backgroundColor = [UIColor darkGrayColor];
    return v;
}

- (BOOL)canAddViewControllersForExposeController:(LIExposeController *)exposeController {
    return YES;
}

- (BOOL)exposeController:(LIExposeController *)exposeController canDeleteViewController:(UIViewController *)viewController {
    return YES;
}

- (UIView *)addViewForExposeController:(LIExposeController *)exposeController {
    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New Tab"]];
    view.frame = CGRectMake(0, 0, 600, 600);
    view.contentMode = UIViewContentModeScaleAspectFill;
    return view;
}

- (void)shouldAddViewControllerForExposeController:(LIExposeController *)exposeController {
    [self addNewViewController:[self makeNewProjectView] animated:YES];
}


- (UIViewController *)makeNewProjectView {
    
    ProjectViewController * projectViewController = [[ProjectViewController alloc] init];
    projectViewController.projectManagerViewController = _projectManagerViewController;
    
    PPNavigationViewController * flipNavigationController =  [[PPNavigationViewController alloc] initWithRootViewController:projectViewController];
    
    flipNavigationController.navigationBar.translucent = NO;
    
    PPPanelViewController *panelViewController = [[PPPanelViewController alloc] initWithRootViewController:flipNavigationController];
    panelViewController.delegate = projectViewController;
    
    return panelViewController;
}

@end
