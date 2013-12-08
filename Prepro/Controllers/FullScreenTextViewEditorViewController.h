//
//  FullScreenTextViewEditorViewController.h
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "BWLongTextViewController.h"
#import "Document.h"

typedef NSString*(^getEntityTextBlock)(id);
typedef void(^setEntityTextBlock)(id, NSString *);

@interface FullScreenTextViewEditorViewController : BWLongTextViewController

@property (atomic, strong) id entity;
@property (atomic, strong) Document *document;
@property(strong) getEntityTextBlock _getEntityTextBlock;
@property(strong) setEntityTextBlock _setEntityTextBlock;

- (void)saveEntity;

@end
