//
//  ProjectViewController.m
//  Prepro
//
//  Created by James Campbell on 23/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "ProjectViewController.h"
#import "PPAppDelegate.h"
#import "Document.h"
#import "MBAlertView.h"
#import "DTCustomColoredAccessory.h"
#import "ProjectManagerViewController.h"

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
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]  initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(exportProject)];
    self.navigationItem.rightBarButtonItem = exportButton;
}

- (void)viewWillAppear:(BOOL)animated {
    titleTextField.text = [NSObject currentProject].title;
    
    titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingProjectTitle)];
    titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [titleTextField addGestureRecognizer:titleDoubleTapGestureRecognizer];
    
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTapRecognizer.numberOfTapsRequired = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
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

- (void)exportProject {
    
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
    [self presentViewController:fpSave animated:YES completion:nil];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Document * document = self.documents[ indexPath.row ];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImage:[document icon]];
    cell.textLabel.text = [document plural];
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor blackColor];
    
    if ([document comingSoon]) {
        cell.imageView.alpha = 0.5;
        cell.textLabel.alpha = 0.5;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Document *document = self.documents[ indexPath.row ];
    
    if (![document comingSoon]) {
        [self.navigationController pushViewController:[document viewControllerForManaging] animated:YES];
    } else {
        [[MBAlertView alertWithBody:@"This feature is coming soon." cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    }
    
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

@end
