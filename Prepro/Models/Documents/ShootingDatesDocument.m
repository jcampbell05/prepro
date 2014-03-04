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
    return [UIImage imageNamed:@"Shooting Dates"];
}

- (NSString *)single {
    return @"Shooting Schedule";
}

- (NSString *)plural {
    return @"Shooting Schedule";
}

- (bool)comingSoon {
    return YES;
}

@end
