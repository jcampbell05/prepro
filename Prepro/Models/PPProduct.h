//
//  PPProduct.h
//  Prepro
//
//  Created by James Campbell on 10/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPProduct : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * subtype;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * priceType;

- (NSString *)priceAsString;

@end
