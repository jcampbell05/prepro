//
//  PPAppStyleManager.m
//  Prepro
//
//  Created by James Campbell on 24/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPAppStyleManager.h"
#import "PPAppStyle.h"
#import "PPAppStyleParser.h"

@interface PPAppStyleManager ()

@end

@implementation PPAppStyleManager

static PPAppStyleManager * instance = nil;

+ (instancetype)sharedInstance {
    
    if ( !instance ) {
        instance = [[PPAppStyleManager alloc] init];
    }
    
    return instance;
}

- (void)setCurrentStyleWithName:(NSString *)name {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"json" inDirectory:@"Styles"];
    
    _appStyle = [PPAppStyleParser parseAppStyleFromFileAtPath: path];
}

@end
