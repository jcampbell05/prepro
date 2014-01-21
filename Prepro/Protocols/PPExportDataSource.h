//
//  PPExportDataSource.h
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPExportDataSource <NSObject>

@required
- (id)exportObject;
- (NSString *)exportTitle;
- (NSArray *)exportTypes;

@end
