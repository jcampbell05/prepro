//
//  CallSheetDocument.m
//  Prepro
//
//  Created by James Campbell on 17/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CallSheetDocument.h"

@implementation CallSheetDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"callsheet"];
}

- (NSString *)single {
    return @"Call Sheet";
}

- (bool)comingSoon {
    return YES;
}


@end
