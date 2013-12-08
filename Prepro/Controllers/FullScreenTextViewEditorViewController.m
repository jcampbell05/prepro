//
//  FullScreenTextViewEditorViewController.m
//  Prepro
//
//  Created by James Campbell on 05/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "FullScreenTextViewEditorViewController.h"
#import "NSObject+AppDelegate.h"
#import "MBAlertView.h"

@interface FullScreenTextViewEditorViewController ()

@end

@implementation FullScreenTextViewEditorViewController

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.entity == nil) {
        self.entity = [[_document entityClass] createNew];
    }
    
    NSString *text = __getEntityTextBlock(_entity);
    self.textView.text = text;
}

- (void)viewWillDisappear:(BOOL)animated {
    __setEntityTextBlock(_entity, self.textView.text);
    [self saveEntity];
    self._getEntityTextBlock = nil;
    self._setEntityTextBlock = nil;
}

- (void)saveEntity {
    NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
    
    NSError *error;
    if(![managedObjectContext save:&error]){
        NSLog(@"Error saving Project.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Project saved.");
    }
}

@end
