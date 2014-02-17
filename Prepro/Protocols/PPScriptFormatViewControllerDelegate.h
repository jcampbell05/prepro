//
//  PPScriptFormatViewControllerDelegate.h
//  Prepro
//
//  Created by James Campbell on 12/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPScriptSection.h"

@protocol PPScriptFormatViewControllerDelegate <NSObject>

@optional
- (void)scriptFormatSectionAdded: (PPScriptSection *)section;
- (void)scriptFormatSectionEdited: (PPScriptSection *)section;

@end
