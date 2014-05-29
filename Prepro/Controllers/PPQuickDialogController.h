//
//  PPQuickDialogController.h
//  Prepro
//
//  Created by James Campbell on 22/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "QuickDialogController.h"
#import "Document.h"
#import "Entity.h"

@interface PPQuickDialogController : QuickDialogController

@property (nonatomic, strong) Entity * entity;

- (instancetype)initWithEntity:(Entity *)entity;
- (void)subSectionElementPressed:(QElement *)element;

@end
