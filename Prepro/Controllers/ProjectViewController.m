//
//  ProjectViewController.m
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: make image view on cells auto invert on selection

#import "ProjectViewController.h"
#import "PPAppDelegate.h"
#import "Document.h"
#import "MBAlertView.h"
#import "DTCustomColoredAccessory.h"
#import "ProjectManagerViewController.h"
#import "LIExposeController.h"
#import "PPDocumentListTableViewCell.h"
#import "UIViewController+PPPanel.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSObject currentProject].title;
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor grayColor];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(37,7, 100,35)];
    titleTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleTextField.backgroundColor = [UIColor clearColor];
    titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleTextField.delegate = self;
    titleTextField.enabled  = NO;
    titleTextField.font = [UIFont systemFontOfSize:20.0];
    titleTextField.opaque = NO;
    titleTextField.textAlignment = NSTextAlignmentCenter;
    titleTextField.textColor = [UIColor whiteColor];
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = titleTextField;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    UIBarButtonItem *tabsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabs-small"] style:UIBarButtonItemStylePlain target:self action:@selector(showTabs)];
    
    self.navigationItem.leftBarButtonItems = @[closeButton, tabsButton];
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(exportProject:)];
    
    self.navigationItem.rightBarButtonItem = exportButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    titleTextField.text = [NSObject currentProject].title;
    
    titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingProjectTitle)];
    titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [titleTextField addGestureRecognizer:titleDoubleTapGestureRecognizer];
    
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTapRecognizer.numberOfTapsRequired = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ( titleTextField.isEditing ){
        [self endEditingProjectTitle];
    } else {
        [self saveProject];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showTabs {
    [self.navigationController.panelController.exposeController toggleExpose:YES];
    [self.navigationController.panelController.exposeController setEditing:YES];
}

- (void)startEditingProjectTitle {
    titleTextField.enabled = YES;
    [titleTextField becomeFirstResponder];
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)endEditingProjectTitle {
    [titleTextField resignFirstResponder];
    titleTextField.enabled = NO;
    
    [NSObject currentProject].title = titleTextField.text;
    [self.view removeGestureRecognizer:singleTapRecognizer];
    
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
    
    // To create the object
    FPSaveController *fpSave = [[FPSaveController alloc] init];
    
    // Set the delegate
    fpSave.fpdelegate = self;
    fpSave.sourceNames = [[NSArray alloc] initWithObjects: FPSourceDropbox, FPSourceGoogleDrive, FPSourceSkydrive, FPSourceGmail, FPSourceGithub, FPSourceBox, nil];
    
    Project *project = [NSObject currentProject];
    
    // Set the data and data type to be saved.
    fpSave.data = [NSKeyedArchiver archivedDataWithRootObject:[project toDictionary]];
    fpSave.dataType = @"text/plain";
    fpSave.dataExtension = @"prp";
    
    //optional: propose the default file name
    fpSave.proposedFilename = project.title;
    
    // Display it.
    UIViewController * pa = self.parentViewController;
    NSLog(@"PVC Stack");
    while (pa) {
        NSLog(@"PVC: %@", [pa debugDescription]);
        pa = pa.parentViewController;
    }
    
    
    /*Display it in pop over*/
    popoverController = [[WYPopoverController alloc] initWithContentViewController:fpSave];
    
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ( [string isEqualToString:@"\n"] ){
        
        if ( titleTextField.text.length == 0 ){
            [[MBAlertView alertWithBody:@"Please enter a project title" cancelTitle:@"Continue" cancelBlock:^{
                [self startEditingProjectTitle];
            }] addToDisplayQueue];
        } else {
            [self endEditingProjectTitle];
        }
        
        return NO;
    }
    
    return YES;
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

- (void)dismissKeyboard {
    [self endEditingProjectTitle];
}

- (void)FPSaveController:(FPSaveController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)FPSaveControllerDidCancel:(FPSaveController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)FPSaveControllerDidSave:(FPSaveController *)picker {
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

@end
