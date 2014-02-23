//
//  ContingencyPlansDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ContingencyPlansDocument.h"

@implementation ContingencyPlansDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Contingency"];
}

- (NSString *)single {
    return @"Contingency";
}

- (bool)comingSoon {
    return YES;
}

@end
