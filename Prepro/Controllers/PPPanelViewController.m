//
//  PPPanelViewController.m
//  Prepro
//
//  Created by James Campbell on 01/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Clean this messy code up

#import "PPPanelViewController.h"
#import "PPPanelViewControllerDelegate.h"
#import "UIViewController+PPPanel.h"
#import <QuartzCore/QuartzCore.h>

@interface PPPanelViewController ()

- (void)insertViewController:(UIViewController *)controller withFrame:(CGRect)rect;
- (void)removeViewController:(UIViewController *)controller;

- (CGRect)rectForPanelInOpenState:(BOOL)open;
- (CGRect)hiddenPositionRect;
- (CGRect)shownPositionRect;

- (void)updateRect:(CGRect)rect ForPanelAnimated:(BOOL)animated completed:(void (^)(void))callback;

@end

@implementation PPPanelViewController


- (id)initWithRootViewController:(UIViewController *)controller {
    
    if (self = [super init]) {
        
        _rootViewController = controller;
        [self insertViewController:_rootViewController withFrame:self.view.bounds];
        [_rootViewController didMoveToParentViewController:self];
        _showingPanel = NO;
        self.definesPresentationContext = YES;
       
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if (_panelViewController ) {
        [self updateRect:[self rectForPanelInOpenState:_showingPanel] ForPanelAnimated:NO completed:nil];
    }
}

- (void)insertViewController:(UIViewController *)controller  withFrame:(CGRect)rect {
    controller.panelController = self;
    controller.view.frame = rect;
    controller.view.autoresizingMask = self.view.autoresizingMask;
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}

- (void)removeViewController:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)showPanelViewController:(UIViewController *)controller {
    
    if (controller == _rootViewController) {
        return;
    }
    
    if (_showingPanel) {
        [self removeViewController:_panelViewController];
        _panelViewController = nil;
    }
    
    _panelViewController = controller;
    _panelViewController.view.frame = [self rectForPanelInOpenState:_showingPanel];
    _panelViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _panelViewController.view.layer.shadowOpacity = 0.8;
    
    [self insertViewController:_panelViewController withFrame:[self rectForPanelInOpenState:_showingPanel]];
    [self.view sendSubviewToBack:_rootViewController.view];
    
    if (!_showingPanel) {

        _showingPanel = YES;
        
        if ([_delegate respondsToSelector:@selector(panelWillShow)]) {
            [_delegate panelWillShow];
        }
        
        [self updateRect:[self rectForPanelInOpenState:_showingPanel] ForPanelAnimated:YES completed:^{
            [controller didMoveToParentViewController:self];
            
            if ([_delegate respondsToSelector:@selector(panelDidShow)]) {
                [_delegate panelDidShow];
            }
        }];
        
    } else {
        
        if ([_delegate respondsToSelector:@selector(panelDidSwap)]) {
            [_delegate panelDidSwap];
        }
    }
}

- (void)hidePanelViewController {
     _showingPanel = NO;
    
    if ([_delegate respondsToSelector:@selector(panelWillHide)]) {
        [_delegate panelWillHide];
    }
    
    [_panelViewController willMoveToParentViewController:nil];
    
    [self updateRect:[self rectForPanelInOpenState:_showingPanel] ForPanelAnimated:YES completed:^{
        
        [self removeViewController:_panelViewController];
        
        if ([_delegate respondsToSelector:@selector(panelDidHide)]) {
            [_delegate panelDidHide];
        }
    }];
    
}

- (CGRect)rectForPanelInOpenState:(BOOL)open {
    if (open) {
        return [self shownPositionRect];
    } else {
        return [self hiddenPositionRect];
    }
}

- (CGRect)hiddenPositionRect {
    return  CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width - PANEL_LEFT_GAP, self.view.frame.size.height);
}

- (CGRect)shownPositionRect {
    return CGRectMake(PANEL_LEFT_GAP, 0, self.view.frame.size.width - PANEL_LEFT_GAP, self.view.frame.size.height);
}

- (void)updateRect:(CGRect)rect ForPanelAnimated:(BOOL)animated completed:(void (^)(void))callback {
    [UIView animateWithDuration:SLIDE_DURATION * animated delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut)
                     animations:^{
                         _panelViewController.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                         if (finished && callback) {
                             callback();
                         }
                     }];
}

//TODO: Improve this rotation animation effect
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateRect:[self rectForPanelInOpenState:_showingPanel] ForPanelAnimated:YES completed:nil];
}

- (BOOL)shouldAutomaticallyForwardRotationMethods{
    return YES;
}

@end
