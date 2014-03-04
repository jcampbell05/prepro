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
    
    _animationBookCoverView.alpha = 1.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        _animationBookCoverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
    }];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
