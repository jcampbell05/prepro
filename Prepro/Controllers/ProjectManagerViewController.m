//
//  ProjectManagerViewController.m
//  Prepro
//
//  Created by James Campbell on 22/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPAppDelegate.h"
#import "UICollectionViewController+ADFlipTransition.h"
#import "UIViewController+ADFlipTransition.h"
#import "NSObject+AppDelegate.h"
#import "ProjectManagerViewController.h"
#import "ProjectCollectionViewCell.h"
#import "Project.h"
#import "MBAlertView.h"
#import "IASKSettingsReader.h"
#import "SplashViewController.h"

@implementation ProjectManagerViewController

static NSString * projectCellIdentifier = @"ProjectCellIdentifier";

- (id)init {
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    ;
    
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewFlowLayout setItemSize:CGSizeMake(ProjectManagerViewCollectionViewCellWidth, ProjectManagerViewCollectionViewCellHeight)];
    [collectionViewFlowLayout setMinimumInteritemSpacing:10];
    [collectionViewFlowLayout setMinimumLineSpacing:10];
    [collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(10, 0, 20, 0)];

    if (self = [super initWithCollectionViewLayout:collectionViewFlowLayout]){
        self.hidesBottomBarWhenPushed = NO;
    }
    
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
     self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Projects";
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.collectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:projectCellIdentifier];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *addProjectButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New"]  style:UIBarButtonItemStylePlain target:self action:@selector(newProject)];
    [addProjectButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *importProjectButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Import"]  style:UIBarButtonItemStylePlain  target:self action:@selector(importProject:)];
    [importProjectButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    editProjectsButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleProjectEditMode)];
    [editProjectsButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    editProjectsButton.enabled = NO;
    
    UIBarButtonItem * settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]  style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    [settingsButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setLeftBarButtonItems:@[addProjectButton, importProjectButton]];
    self.navigationItem.rightBarButtonItems = @[settingsButton, editProjectsButton];
    
    deleteProjectsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeProjects)];
    deleteProjectsButton.tintColor = [UIColor redColor];
    
    
    selectedCount = [[UILabel alloc] initWithFrame:CGRectMake(37,7,250,35)];
    selectedCount.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    selectedCount.backgroundColor = [UIColor clearColor];
    selectedCount.textColor = [UIColor whiteColor];
    selectedCount.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *selectedCountWrapper = [[UIBarButtonItem alloc] initWithCustomView:selectedCount];
    
    toolbarItems = @[deleteProjectsButton, selectedCountWrapper];
    projects = [[NSMutableArray alloc] init];
    
    [self setToolbarItems:toolbarItems animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateWithForce:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    if ( self.isEditing ){
        [self toggleProjectEditMode];
    }
}

- (void)newProject {
    [self showProject:Nil fromIndexPath:nil];
}

- (void)importProject:(id)sender {
    // To create the object
    FPPickerController *fpController = [[FPPickerController alloc] init];
    
    // Set the delegate
    fpController.fpdelegate = self;
    
    // Ask for specific data types. (Optional) Default is all files.
    fpController.dataTypes = [NSArray arrayWithObjects:@"*/*", nil];
    
    // Select and order the sources (Optional) Default is all sources
    fpController.sourceNames = [[NSArray alloc] initWithObjects: FPSourceDropbox, FPSourceGoogleDrive, FPSourceSkydrive, FPSourceGmail, FPSourceGithub, FPSourceBox, nil];
    
    // You can set some of the in built Camera properties as you would with UIImagePicker
    fpController.allowsEditing = YES;
    
    
    /* Control if we should upload or download the files for you.
     * Default is yes.
     * When a user selects a local file, we'll upload it and return a remote url
     * When a user selects a remote file, we'll download it and return the filedata to you.
     */
    fpController.shouldUpload = YES;
    fpController.shouldDownload = YES;
    
    /*Display it in pop over*/
    popoverController = [[WYPopoverController alloc] initWithContentViewController:fpController];
    
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (BOOL)loadProjects {
    NSLog(@"Fetching projects.");
    
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication]. delegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error;
    
    NSMutableArray * fetchedProjects = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!fetchedProjects) {
        NSLog(@"Failed to load projects");
        
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
        
        return NO;
    } else {
        
        if (projects && projects.count == fetchedProjects.count) {
            NSLog(@"No More Projects to Load");
            return NO;
        }
        
        projects = fetchedProjects;
        
        NSLog(@"Loaded projects");
        
        return YES;
    }
}

- (void)showSettings:(id)sender {
    
    IASKAppSettingsViewController *settingsController = [[IASKAppSettingsViewController alloc] init];
    settingsController.delegate = self;
    settingsController.showCreditsFooter = NO;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
      /*Display it in pop over*/
    popoverController = [[WYPopoverController alloc] initWithContentViewController:navigationController];
    
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (void)removeProjects {
    
    int noSelected = [self.collectionView.indexPathsForSelectedItems count];
    
    NSString *message;
    
    if(noSelected == 1){
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems[0];
        Project *project = projects[indexPath.row];
        message = [NSString stringWithFormat:@"Are you sure you want to delete \"%@\"?", project.title];
    } else {
        message = [NSString stringWithFormat:@"Are you sure you want to delete all %i projects?", noSelected];
    }
    
    MBAlertView *alert = [MBAlertView alertWithBody:message cancelTitle:@"No" cancelBlock:nil];
    [alert addButtonWithText:@"Delete" type:MBAlertViewItemTypeDestructive block:^{
        [self.collectionView.indexPathsForSelectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            
            Project *project = projects[indexPath.row];
            
            NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
            
            [managedObjectContext deleteObject:project];
            
            NSError *error;
            
            if(![managedObjectContext save:&error]){
                NSLog(@"Error deleting selected projects.");
                [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
            } else {
                NSLog(@"Projects deleted.");
            }
        }];
        [self loadProjects];
        [self.collectionView deleteItemsAtIndexPaths:self.collectionView.indexPathsForSelectedItems];
        [self updateButtons];
        [self updateToolbar];
    }];
    [alert addToDisplayQueue];
}

- (void)updateButtons {

    if ( editProjectsButton){
        if (projects && projects.count > 0){
            editProjectsButton.enabled = YES;
        } else {
            
            if ( self.isEditing ){
                [self toggleProjectEditMode];
            }
            
            editProjectsButton.enabled = NO;
        }
    }
}

//TODO: Add Animated Trashcan
- (void)updateToolbar {
    int noSelected = [self.collectionView.indexPathsForSelectedItems count];
    
    if (noSelected == 0){
        deleteProjectsButton.enabled = NO;
    } else {
        deleteProjectsButton.enabled = YES;
    }
    
    selectedCount.text = [NSString stringWithFormat:@"%i of %i selected", noSelected, [projects count]];
}

- (void)toggleProjectEditMode {
    if ( !self.isEditing ){
        NSLog(@"Is entering edit mode");
        
        [editProjectsButton setTitle:@"Done"];
        [editProjectsButton setStyle:UIBarButtonItemStyleDone];
        
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self setEditing:YES animated:YES];
    } else {
        NSLog(@"Is exiting edit mode");
        
        [editProjectsButton setTitle:@"Edit"];
        [editProjectsButton setStyle:UIBarButtonItemStylePlain];

        self.collectionView.allowsMultipleSelection = NO;
        self.collectionView.allowsSelection = NO;
        self.collectionView.allowsSelection = YES;
        
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self setEditing:NO animated:YES];
    }
    
    [self updateToolbar];
}

- (void)projectSelectedAtCellIndexPath:(NSIndexPath *)indexPath {
    [self showProject:projects[ indexPath.row ] fromIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [projects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCollectionViewCell * cell = (ProjectCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:projectCellIdentifier forIndexPath:indexPath];
    
    if ( cell == nil )
    {
        cell = [[ProjectCollectionViewCell alloc] init];
    }
    
    Project *project = projects[indexPath.row];
    cell.title = project.title;
    
    return (UICollectionViewCell *)cell;
}

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ( !self.isEditing ){
       [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
       [self projectSelectedAtCellIndexPath:indexPath];
    } else {
        [self updateToolbar];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( self.editing ){
        [self updateToolbar];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSLog(@"Downloading Project File From %@.", info[@"FPPickerControllerRemoteURL"]);
    
    //TODO: Make Import/Export Method Part Of App :)
    NSURL *fileURL = [NSURL URLWithString:info[@"FPPickerControllerRemoteURL"]];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSLog(@"%@", data);
    NSDictionary *projectData = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication]. delegate managedObjectContext];
    
    Project *project = (Project *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
    [project populateFromDictionary:projectData];
    
    NSError *error;
    if(![managedObjectContext save:&error]){
        NSLog(@"Error importing project.");
    } else {
        NSLog(@"New project imported.");
    }

    [self loadProjects];
    
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];

    [popoverController dismissPopoverAnimated:YES];
}

- (void)FPPickerController:(FPPickerController *)picker didPickMediaWithInfo:(NSDictionary *)info {
    [popoverController dismissPopoverAnimated:YES];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
    [popoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

- (CGFloat)settingsViewController:(id<IASKViewController>)settingsViewController
                        tableView:(UITableView *)tableView
        heightForHeaderForSection:(NSInteger)section {
    NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"Logo"].size.height + 25;
	}
	return 0;
}

- (UIView *)settingsViewController:(id<IASKViewController>)settingsViewController
                         tableView:(UITableView *)tableView
           viewForHeaderForSection:(NSInteger)section {
    NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
		imageView.contentMode = UIViewContentModeCenter;
		return imageView;
	}
	return nil;
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
     [popoverController dismissPopoverAnimated:YES];
}

- (void)showProject: (Project *)project fromIndexPath:(NSIndexPath *)indexPath {
    
    PPAppDelegate *appDelegate = (PPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (project == nil) {
        appDelegate.currentProject = [Project createNew];
    } else {
        appDelegate.currentProject = project;
    }
    
    NSLog(@"Opening \"%@\".", appDelegate.currentProject.title);
    
    if (exposeController) {
        exposeController = nil;
    }
    
    exposeController = [[PPExposeController alloc] initWithProjectManager:self];
    exposeController.view.frame = self.view.frame;
    
    if (indexPath == nil) {
        [self flipToViewController:exposeController fromView:self.view withCompletion:NULL];
    } else {
        [self flipToViewController:exposeController fromItemAtIndexPath:indexPath withCompletion:NULL];
    }
}

- (void)closeProject {
    [self updateWithForce:YES];
    
    PPAppDelegate *appDelegate = (PPAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUInteger row = [projects indexOfObject:appDelegate.currentProject];
    
    if (row == NSNotFound) {
        [exposeController dismissFlipWithCompletion:NULL];
    } else {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[@(row) intValue] inSection:0];
        [exposeController dismissFlipToIndexPath:indexPath withCompletion:NULL];
    }
    
    
}

- (void)updateWithForce:(BOOL)force {
    if ( [self loadProjects] || force ) {
        [self updateButtons];
        [self.collectionView reloadData];
    }
}

@end
