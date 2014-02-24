//
//  PPAppStyleParser.m
//  Prepro
//
//  Created by James Campbell on 24/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPAppStyleParser.h"
#import "PPAppStyle.h"
#import "HexColor.h"

@implementation PPAppStyleParser

+ (PPAppStyle *)parseAppStyleFromFileAtPath:(NSString *)path {
    
    if (path == nil) {
        return nil;
    }
    
    PPAppStyle * result = [[PPAppStyle alloc] init];
    
    NSData * jsonData = [NSData dataWithContentsOfFile: path];
    id jsonObject = [NSJSONSerialization JSONObjectWithData: jsonData options:NULL error:nil];
    
    NSArray * keys = [jsonObject allKeys];
    
    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL *stop) {
        
        NSString * value = [jsonObject valueForKey: key];
        UIColor * color = [UIColor colorWithHexString: value];
        
        [result setValue:color forKey: key];
        
    }];
    
    return result;
}

@end
