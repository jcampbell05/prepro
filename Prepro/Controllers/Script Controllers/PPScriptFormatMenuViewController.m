//
//  PPScriptFormatMenuViewController.m
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptFormatMenuViewController.h"
#import "PPScriptFormatter.h"
#import "PPScriptFormatEntryViewController.h"

@interface PPScriptFormatMenuViewController ()

@end

@implementation PPScriptFormatMenuViewController

#pragma mark UIViewController Lifecycle

- (id)initWithFormatters:(NSArray *)formatters andDelegate:(id<PPScriptFormatViewControllerDelegate>) delegate {
    
    if ( self = [super init] ) {
        
       _formatters = formatters;
    _delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.navigationItem.title = @"Add New";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _formatters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if ( !cell ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    PPScriptFormatter * formatter = _formatters[ indexPath.row ];
    
    cell.textLabel.text = formatter.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PPScriptFormatter * formatter = _formatters[ indexPath.row ];
    
    PPScriptFormatEntryViewController * quickDialogController = [PPScriptFormatEntryViewController controllerForRoot: formatter.visualEditForm];
    quickDialogController.delegate = _delegate;
    quickDialogController.formatter = formatter;
    
    [self.navigationController pushViewController: quickDialogController animated: YES];
    
}

#pragma mark Implementation

- (void)dismiss {
     [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion: nil];
}

@end
