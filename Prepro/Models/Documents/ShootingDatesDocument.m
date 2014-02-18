//
//  ShootingDatesDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ShootingDatesDocument.h"

@implementation ShootingDatesDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"shooting dates"];
}

- (NSString *)single {
    return @"Shooting Date";
}

- (NSString *)plural {
    return @"Shooting Dates";
}

- (bool)comingSoon {
    return YES;
}

@end
