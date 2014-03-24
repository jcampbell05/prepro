//
//  PPProduct.m
//  Prepro
//
//  Created by James Campbell on 10/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPProduct.h"

@implementation PPProduct

- (NSString *)priceAsString {
    
    if ( [self.priceType isEqualToString:@"Call"] ) {
        
        return self.priceType;
    }
    
    return [NSString stringWithFormat:@"£%@ %@", self.price, self.priceType];
}

@end
