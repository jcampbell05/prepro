//
//  SplashViewController.m
//  CalgaryEats
//
//  Created by Jeremy Gale on 2012-02-20.
//  Copyright (c) 2012 Force Grind Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import <QuartzCore/QuartzCore.h>
#import "SplashViewController.h"

@implementation SplashViewController

- (void)loadView
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (([[UIScreen mainScreen] bounds].size.height > 480.1))
        {
            // iOS 6 doesn't seem to automatically pull out the iPhone 5 sized image so we manually need to load it
            // if running on an iPhone 5.
            _animationBookCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h"]];
        }
        else
        {
            _animationBookCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
        }
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {          
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            _animationBookCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Landscape"]];
        }
        else
        {
            _animationBookCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Portrait"]];
        }
    }
    
    self.view = _animationBookCoverView;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    _animationBookCoverView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Credit to this smart cookie:
    // http://mo7amedfouad.com/2011/12/book-cover-flip-animation-like-in-path-app/
    
    _animationBookCoverView.layer.anchorPoint = CGPointMake(0, .5);
    _animationBookCoverView.center = CGPointMake(_animationBookCoverView.center.x - _animationBookCoverView.bounds.size.width/2.0f, _animationBookCoverView.center.y);
    [UIView beginAnimations:@"openBook" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:0];
    CATransform3D _3Dt = CATransform3DIdentity;
    _3Dt = CATransform3DMakeRotation(M_PI/2.0, 0.0f, -1.0f, 0.0f);
    _3Dt.m34 = 0.001f; // Perspective
    
    _animationBookCoverView.layer.transform = _3Dt;
    [UIView commitAnimations];
    
    // Super hack. Adding a view to the window in Landscape on an iPad just doesn't work.
    // Used this guy's approach to manually rotate it:
    // http://stackoverflow.com/questions/1484799/only-first-uiview-added-view-addsubview-shows-correct-orientation/2694563#2694563
    // And then I learned that LandscapeLeft and PortraitUpsideDown need to be rotated an extra 180
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGAffineTransform rotate;
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            rotate = CGAffineTransformMakeRotation(M_PI/2.0);
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            rotate = CGAffineTransformMakeRotation(M_PI);
        }
        else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            rotate = CGAffineTransformMakeRotation(1.5 * M_PI);
        }
        else
        {
            // UIInterfaceOrientationPortrait - Only one that works without hacks
            return;
        }
        
        [self.view setTransform:rotate];
        self.view.frame = CGRectMake(0, 0, 1024, 768);
    }

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
