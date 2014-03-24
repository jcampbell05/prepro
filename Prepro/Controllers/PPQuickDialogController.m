//
//  PPQuickDialogController.m
//  Prepro
//
//  Created by James Campbell on 22/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPQuickDialogController.h"
#import "ProjectViewController.h"

@interface PPQuickDialogController ()

@property (nonatomic, strong) UIBarButtonItem * exposeButton;
@property (nonatomic, strong) UIBarButtonItem * documentListButton;

- (void)createExposeBarButton;
- (void)createDocumentListBarButton;

- (void)exposePressed;
- (void)documentListPressed;

@end

@implementation PPQuickDialogController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createExposeBarButton];
    [self createDocumentListBarButton];
    
    self.navigationItem.rightBarButtonItems = @[self.exposeButton, self.documentListButton];
}

- (void)createExposeBarButton {
    
    self.exposeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Expose"] style:UIBarButtonItemStylePlain target:self action:@selector(exposePressed)];
}

- (void)createDocumentListBarButton {
    
    self.documentListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List View"]  style:UIBarButtonItemStylePlain target:self action:@selector(documentListPressed)];
}

- (void)exposePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:exposeNotification object:nil];
}

- (void)documentListPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:documentListNotification object:nil];
}

@end
