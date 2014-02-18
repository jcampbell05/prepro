//
//  PPScriptFormatter.h
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Maybe rename from Formmater to SectionDefinition ? 

#import <Foundation/Foundation.h>
#import "QuickDialog.h"
#import "PPScriptSection.h"


@interface PPScriptFormatter : NSObject

- (QRootElement *)visualEditForm;

- (PPScriptSection *)scriptSectionForFormat;

- (NSString *)title;

@end
