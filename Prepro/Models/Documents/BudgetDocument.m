//
//  BudgetDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "BudgetDocument.h"

@implementation BudgetDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Budget"];
}

- (NSString *)single {
    return @"Budget";
}

- (bool)comingSoon {
    return YES;
}

@end
