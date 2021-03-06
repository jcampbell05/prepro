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

    self.navigationItem.title = [NSObject currentProject].title;
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor grayColor];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    UIBarButtonItem *tabsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabs-small"] style:UIBarButtonItemStylePlain target:self action:@selector(showTabs)];
    
    self.navigationItem.leftBarButtonItems = @[closeButton, tabsButton];
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"export"]  style:UIBarButtonItemStylePlain target:self action:@selector(exportProject:)];
    
    self.navigationItem.rightBarButtonItem = exportButton;
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
    return 2;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return [self.documents count];
    } else {
        //TODO: Remove all this strange hackery when we finally finish the new UI as we won't need this
        return (self.navigationController.panelController.showingPanel) ? 2 : 0;
    }
    
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
    cell.backgroundColor = [UIColor blackColor];
    
    if (indexPath.section == 1) {
    
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
        
    } else {
        
        cell.imageView.alpha = 1;
        cell.textLabel.alpha = 1;
        
        if (indexPath.row == 0) {
            [cell setImage:[UIImage imageNamed:@"tabs"]];
        } else {
            [cell setImage:[UIImage imageNamed:@"documentList"]];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self showTabs];
        } else {
            currentDocument = nil;
        
            [self.navigationController.panelController hidePanelViewController];
        }
    
    } else {
    
        Document *document = self.documents[ indexPath.row ];
        
        if (![document comingSoon]) {
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[document viewControllerForManaging]];
            navigationController.view.frame = CGRectMake(navigationController.view.frame.origin.x, navigationController.view.frame.origin.y, 270, navigationController.view.frame.size.height);
            navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            
            if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0" )) {
                navigationController.navigationBar.tintColor = [UIColor whiteColor];
                navigationController.navigationBar.barTintColor = [UIColor blackColor];
                navigationController.navigationBar.translucent = NO;
            }
            
            currentDocument = indexPath;

            //TODO: Remove need for navigation controller
            [self.navigationController.panelController showPanelViewController:navigationController];
            
        } else {
            [[MBAlertView alertWithBody:@"This feature is coming soon." cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
        }
        
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

- (void)panelWillShow {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    [self.tableView selectRowAtIndexPath:currentDocument animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)panelWillHide {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
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
