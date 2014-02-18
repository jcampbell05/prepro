//
//  PPDocumentView.h
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDocumentView : NSObject

@property (strong, atomic) NSString * title;
@property (strong, atomic) UIViewController * viewController;

@end
