//
//  PPExportTypeViewController.m
//  Prepro
//
//  Created by James Campbell on 20/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPExportTypeViewController.h"
#import "PPExportType.h"
#import <FPPicker/FPPicker.h>
#import "NSObject+AppDelegate.h"

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
    FPSaveController *fpSave = [[FPSaveController alloc] init];
    
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
    
    //Caused Issues in 1.3 - fix in 1.3.1
    //[self.navigationController pushViewController:fpSave animated:YES];
    
    //Hack until we fix it
    UIViewController * presentor = self.presentingViewController;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        fpSave.delegate = presentor;
        [presentor presentViewController:fpSave animated:YES completion:nil];
    }];
    
}

@end
