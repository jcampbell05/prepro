//
//  MBAlertAbstract.m
//  Freebie
//
//  Created by Mo Bitar on 5/2/13.
//  Copyright (c) 2013 progenius. All rights reserved.
//

#import "MBAlertAbstract.h"
#import "MBAlertViewSubclass.h"
#import "MBHUDView.h"
#import "MBAlertViewButton.h"
#import "UIView+Alert.h"
#import <QuartzCore/QuartzCore.h>

NSString *const MBAlertDidAppearNotification = @"MBAlertDidAppearNotification";
NSString *const MBAlertDidDismissNotification = @"MBAlertDidDismissNotification";

@interface MBAlertAbstract ()
@property (nonatomic, assign) BOOL viewHasLoaded;
@end

@implementation MBAlertAbstract {
    BOOL isPendingDismissal;
}

static NSMutableArray *retainQueue;
static NSMutableArray *displayQueue;
static NSMutableArray *dismissQueue;
static MBAlertAbstract *currentAlert;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRotation:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    return self;
}

- (void)addToDisplayQueue {
    if(!displayQueue)
        displayQueue = [[NSMutableArray alloc] init];
    if(!dismissQueue)
        dismissQueue = [[NSMutableArray alloc] init];
    
    [displayQueue addObject:self];
    [dismissQueue addObject:self];
    
    if(retainQueue.count == 0 && !currentAlert) {
        // show now
        currentAlert = self;
        [self addToWindow];
        [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertDidAppearNotification object:self];
    }
}

- (void)addToWindow {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];

    if(self.addsToWindow)
        [window addSubview:self.view];
    else [[[window subviews] objectAtIndex:0] addSubview:self.view];
    
    [self performLayout];
    
    [window resignFirstRespondersForSubviews];
    
    [self addBounceAnimationToLayer:self.view.layer];
    [displayQueue removeObject:self]; 
}

- (void)performLayout {
    
}

- (void)dismiss {
    if(isPendingDismissal)
        return;
    isPendingDismissal = YES;
    
    if(!retainQueue)
        retainQueue = [[NSMutableArray alloc] init];
    
    [self.hideTimer invalidate];
    [retainQueue addObject:self];
    [dismissQueue removeObject:self];
    
    currentAlert = nil;
    [self addDismissAnimation];
}

- (void)removeAlertFromView {
    id block = self.uponDismissalBlock;
    if (![block isEqual:[NSNull null]] && block) {
        ((void (^)())block)();
    }
    
    self.view.hidden = YES;
    
    [self.view removeFromSuperview];
    [retainQueue removeObject:self];
    
    if(displayQueue.count > 0) {
        MBAlertAbstract *alert = [displayQueue objectAtIndex:0];
        currentAlert = alert;
        [currentAlert addToWindow];
    }
}

+ (void)dismissCurrentHUD {
    if(dismissQueue.count > 0) {
        MBAlertAbstract *current = [dismissQueue lastObject];
        [displayQueue removeObject:current];
        [current dismiss];
        [dismissQueue removeLastObject];
    }
}

+ (void)dismissCurrentHUDAfterDelay:(float)delay {
    [[MBAlertAbstract class] performSelector:@selector(dismissCurrentHUD) withObject:nil afterDelay:delay];
}

+ (BOOL)alertIsVisible {
    if(currentAlert)
        return YES;
    return NO;
}

- (void)didRemoveHighlightFromButton:(MBAlertViewButton*)button {
    [button.layer removeAllAnimations];
}

- (void)setRotation:(NSNotification*)notification {
    if (self.viewHasLoaded){
        [self performSelector:@selector(layoutButtonsWrapper) withObject:nil afterDelay:0.01];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewHasLoaded = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}

#define transform(x, y, z) [NSValue valueWithCATransform3D:CATransform3DMakeScale(x, y, z)]

- (void)addDismissAnimation {
    NSArray *frameValues = @[transform(1.0, 1.0, 1), transform(0.95, 0.95, 1), transform(1.15, 1.15, 1), transform(0.01, 0.01, 1.0)];
    NSArray *frameTimes = @[@(0.0), @(0.1), @(0.5), @(1.0)];
    CAKeyframeAnimation *popAnimation = [self.class animationWithValues:frameValues times:frameTimes duration:0.4];
    popAnimation .timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *fadeAnimtion = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimtion.beginTime = 0.2;
    fadeAnimtion.duration = 0.2;
    fadeAnimtion.fromValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimtion.toValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimtion.additive = NO;
    fadeAnimtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:0.4];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations:
     @[popAnimation , fadeAnimtion]];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            [self.view setHidden:YES];
            [self removeAlertFromView];
        }];
        [self.view.layer addAnimation:group forKey:@"exit"];
    } [CATransaction commit];
}

- (void)addBounceAnimationToLayer:(CALayer*)layer {
    NSArray *frameValues = @[transform(0.1, 0.1, 0.1), transform(1.15, 1.15, 1.15), transform(0.9, 0.9, 0.9), transform(1.0, 1.0, 1.0)];
    NSArray *frameTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
    [layer addAnimation:[self.class animationWithValues:frameValues times:frameTimes duration:0.4] forKey:@"popup"];
    
    CABasicAnimation *fadeAnimtion = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimtion.duration = 0.2;
    fadeAnimtion.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimtion.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimtion.removedOnCompletion = YES;
    fadeAnimtion.fillMode = kCAFillModeForwards;
    fadeAnimtion.additive = NO;
    fadeAnimtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:fadeAnimtion forKey:@"opacity"];

}

- (void)didSelectBodyLabel:(UIButton*)bodyLabelButton {
    NSArray *frameValues = @[transform(1.0, 1.0, 1), transform(1.08, 1.08, 1), transform(0.95, 0.95, 1), transform(1.02, 1.02, 1), transform(1.0, 1.0, 1)];
    NSArray *frameTimes = @[@(0.0), @(0.1), @(0.7), @(0.9), @(1.0)];
    [bodyLabelButton.layer addAnimation:[self.class animationWithValues:frameValues times:frameTimes duration:0.3] forKey:@"popup"];
}

- (void)didHighlightButton:(MBAlertViewButton*)button {
    NSArray *frameValues = @[transform(1.0, 1.0, 1), transform(1.25, 1.25, 1.0)];
    NSArray *frameTimes = @[@(0.0), @(0.5)];
    [button.layer addAnimation:[self.class animationWithValues:frameValues times:frameTimes duration:0.25] forKey:@"popup"];
}

+ (CAKeyframeAnimation*)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.keyTimes = times;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    return animation;
}

@end