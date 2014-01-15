//
//  Script.h
//  Prepro
//
//  Created by James Campbell on 02/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "Entity.h"

@interface Script : Entity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSAttributedString * content;

@end
