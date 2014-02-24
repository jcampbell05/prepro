//
//  PPAppStyleManager.h
//  Prepro
//
//  Created by James Campbell on 24/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Build this up, look into CSS Frameworks for iOS Apps.

#import <Foundation/Foundation.h>

@class PPAppStyle;

@interface PPAppStyleManager : NSObject

@property (strong, nonatomic) PPAppStyle * appStyle;

+ (instancetype)sharedInstance;

- (void)setCurrentStyleWithName:(NSString *)name;

@end
