//
//  PPQuickDialogController.m
//  Prepro
//
//  Created by James Campbell on 22/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// TODO: Make it easier to save entities without document.

#import "PPQuickDialogController.h"
#import "ProjectViewController.h"
#import "ALFSAlert.h"

@interface PPQuickDialogController ()

@property (nonatomic, strong) UIBarButtonItem * exposeButton;
@property (nonatomic, strong) UIBarButtonItem * documentListButton;

- (void)createExposeBarButton;
- (void)createDocumentListBarButton;

- (void)exposePressed;
- (void)documentListPressed;

@end

@implementation PPQuickDialogController

- (instancetype)initWithEntity:(Entity *)entity {

    self.entity = entity;
    
    QRootElement  *root = [[QRootElement alloc] initWithJSONFile: NSStringFromClass([entity class]) ];
    root.controllerName = NSStringFromClass([PPQuickDialogController class]);
    [root bindToObject: entity];
    
    if ( self = [super initWithRoot: root] ) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createExposeBarButton];
    [self createDocumentListBarButton];
    
    self.navigationItem.rightBarButtonItems = @[self.exposeButton, self.documentListButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    [self.root fetchValueIntoObject: self.entity];
    
    NSLog(@"Entity: %@", [self.entity description]);
    
    //Tell entity we are about to save it so it can do some last minute processing - We need to alter this ave method as its getting tangled
    [self.entity onSave: nil];
    
    NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
    
    NSError *error;
    if(![managedObjectContext save:&error]){
        NSLog(@"Error saving Project.");
        
        ALFSAlert * alert = [[ALFSAlert alloc] initInViewController: self.parentViewController];
        
        [alert showAlertWithMessage: error.description];
        [alert addButtonWithText:@"Continue" forType:ALFSAlertButtonTypeNormal onTap:^{
            
            [alert removeAlert];
        }];
        
    } else {
        NSLog(@"Project saved.");
    }
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

- (void)subSectionElementPressed:(QLabelElement *)element {
    
    QRootElement * root = [[QRootElement alloc] initWithJSONFile: [NSString stringWithFormat:@"Subpages/%@/%@", NSStringFromClass(self.entity.class),  element.title]];
    
    PPQuickDialogController * quickDialogController = [[PPQuickDialogController alloc] initWithRoot: root];
    quickDialogController.entity = self.entity;
    
    [self.navigationController pushViewController: quickDialogController animated:YES];
}

@end
