//
//  RiskAssessmentDocument.m
//  Prepro
//
//  Created by James Campbell on 15/12/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "RiskAssessmentDocument.h"

@implementation RiskAssessmentDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Risk Assessment"];
}

- (NSString *)single {
    return @"Risk Assesment";
}

- (bool)comingSoon {
    return YES;
}

@end
