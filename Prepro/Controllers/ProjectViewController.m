//
//  ProjectViewController.m
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: make image view on cells auto invert on selection, also reduce code

#import "ProjectViewController.h"
#import "PPAppDelegate.h"
#import "PPAppStyleManager.h"
#import "PPAppStyle.h"
#import "Document.h"
#import "MBAlertView.h"
#import "DTCustomColoredAccessory.h"
#import "ProjectManagerViewController.h"
#import "LIExposeController.h"
#import "PPDocumentListTableViewCell.h"
#import "UIViewController+PPPanel.h"
#import "PPExportTypeViewController.h"
#import "PPPreproProjectExportType.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

static NSString *CellIdentifier = @"CellIdentifier";


- (void)loadView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.view = _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    PPAppStyle * appStyle = [[PPAppStyleManager sharedInstance] appStyle];
    
    self.navigationItem.title = [NSObject currentProject].title;
    
    self.tableView.backgroundColor = appStyle.primaryColour;
    self.tableView.separatorColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Projects"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [closeButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *tabsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Expose"] style:UIBarButtonItemStylePlain target:self action:@selector(showTabs)];
    [tabsButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Export"]  style:UIBarButtonItemStylePlain target:self action:@selector(exportProject:)];
    [exportButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List View"]  style:UIBarButtonItemStylePlain target:self action:@selector(class)];
    [listButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItems = @[closeButton, exportButton];
    self.navigationItem.rightBarButtonItems = @[tabsButton, listButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.title = [NSObject currentProject].title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showTabs {
    [self.navigationController.panelController.exposeController toggleExpose:YES];
    [self.navigationController.panelController.exposeController setEditing:YES];
}

- (void)save {
    
    [NSObject currentProject].title = self.title;
    
    [self saveProject];
}

- (void)saveProject {
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication]. delegate managedObjectContext];
    
    NSError *error;
    if(![managedObjectContext save:&error]){
        NSLog(@"Error saving project.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Project saved.");
    }
}

- (void)exportProject:(id)sender {
    
    [self saveProject];
    
    PPExportTypeViewController * exportTypeViewController = [[PPExportTypeViewController alloc] initWithDataSource:self];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:exportTypeViewController];
    
    /*Display it in pop over - diabled in 1.3 due to issues with new export feaure, restore old 1.2.1 popover feature, perhaps with different Popover library ?*/
//    popoverController = [[WYPopoverController alloc] initWithContentViewController:navigationController];
//    
//    [popoverController presentPopoverFromBarButtonItem:exportTypeViewController permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (NSArray *)documents {
    return [(PPAppDelegate*)[UIApplication sharedApplication].delegate documents];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.documents count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor whiteColor];
    
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor blackColor];
    
    cell.accessoryView = accessory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PPDocumentListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PPDocumentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    
    Document * document = self.documents[ indexPath.row ];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell setImage:[document icon]];
    cell.textLabel.text = [document plural];
    
    if ([document comingSoon]) {
        cell.imageView.alpha = 0.5;
        cell.textLabel.alpha = 0.5;
    } else {
        cell.imageView.alpha = 1;
        cell.textLabel.alpha = 1;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Document *document = self.documents[ indexPath.row ];
    
    if (![document comingSoon]) {
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[document viewControllerForManaging]];
        navigationController.view.frame = CGRectMake(navigationController.view.frame.origin.x, navigationController.view.frame.origin.y, 270, navigationController.view.frame.size.height);
        
        currentDocument = indexPath;

        //TODO: Remove need for navigation controller
        [self.navigationController.panelController showPanelViewController:navigationController];
        
    } else {
        [[MBAlertView alertWithBody:@"This feature is coming soon." cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    }
    
    [self.tableView selectRowAtIndexPath:currentDocument animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

- (void)FPSaveController:(FPSaveController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //Hack for 1.3
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   //1.2 - Code get working for 1.3 +
    // [popoverController dismissPopoverAnimated:YES];
}

- (void)FPSaveControllerDidCancel:(FPSaveController *)picker {
    
    //Hack for 1.3
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //1.2 - Code get working for 1.3 +
   // [popoverController dismissPopoverAnimated:YES];
    return;
}

- (void)FPSaveControllerDidSave:(FPSaveController *)picker {
    
    //Hack for 1.3
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //1.2 - Code get working for 1.3 +
    //[popoverController dismissPopoverAnimated:YES];
    return;
}

- (IBAction)backPressed:(UIButton *)sender {
    [self.projectManagerViewController closeProject];
}

- (void)panelDidSwap {
    
}

#pragma mark PPExportDataSource

- (id)exportObject {
    return [NSObject currentProject];
}

- (NSString *)exportTitle {
    return [NSObject currentProject].title;
}

- (NSArray *)exportTypes {
    return @[
        [PPPreproProjectExportType alloc]
    ];
}

@end
