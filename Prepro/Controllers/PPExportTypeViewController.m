//
//  PPExportTypeViewController.m
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPExportTypeViewController.h"
#import "PPExportType.h"
#import "PPExposeController.h"
#import "PPPanelViewController.h"
#import <FPPicker/FPPicker.h>
#import "NSObject+AppDelegate.h"
#import "PPSaveControllerViewController.h"

@interface PPExportTypeViewController ()

@end

@implementation PPExportTypeViewController

- (id)initWithDataSource:(id<PPExportDataSource>) dataSource {
    
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _dataSource = dataSource;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    self.navigationItem.title = [NSString stringWithFormat:@"Export: %@", [_dataSource exportTitle]];
    
    UIBarButtonItem * closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed)];
    
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    _exportTypes = [_dataSource exportTypes];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_exportTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    PPExportType * exportType = _exportTypes[ indexPath.row ];
    
    cell.textLabel.text = exportType.name;
    cell.detailTextLabel.text = exportType.description;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // To create the object
    PPSaveControllerViewController *fpSave = [[PPSaveControllerViewController alloc] init];
    
    // Set the delegate
    //fpSave.fpdelegate = self;
    fpSave.sourceNames = [[NSArray alloc] initWithObjects: FPSourceDropbox, FPSourceGoogleDrive, FPSourceSkydrive, FPSourceGmail, FPSourceGithub, FPSourceBox, nil];
    
    PPExportType * exportType = _exportTypes[ indexPath.row ];
    Project *project = [NSObject currentProject];
    
    // Set the data and data type to be saved.
    fpSave.data = [exportType generateExportDataFromObject:[_dataSource exportObject]];
    fpSave.dataType = [exportType mimeType];
    fpSave.dataExtension = [exportType extension];
    
    //optional: propose the default file name
    fpSave.proposedFilename = project.title;
    
    //New Expose screen in 1.5
    
    //Caused Issues in 1.3
    //[self.navigationController pushViewController:fpSave animated:YES];
    
    //Hack until we fix it
    UIViewController * presentor = self.presentingViewController;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //This is hacky
        PPExposeController * expose = presentor;
        PPPanelViewController * panel = expose.selectedViewController;
        
        UINavigationController * nav = panel.rootViewController;
        
        [presentor presentViewController:fpSave animated:YES completion:nil];
    }];
    
}
    
- (void)closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
