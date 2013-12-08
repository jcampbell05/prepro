//
//  EntityManagerViewController.m
//  Prepro
//
//  Created by James Campbell on 07/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//
// TODO: Make More Modular

#import "EntityManagerViewController.h"
#import "Project.h"
#import "NSObject+AppDelegate.h"
#import "BatchNumberPickerViewController.h"
#import "MBAlertView.h"
#import "Entity.h"
#import "PPAppDelegate.h"
#import "ProjectViewController.h"

@interface EntityManagerViewController ()

@end

@implementation EntityManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0" )) {
            self.tableView.tintColor = [UIColor redColor];
        }
        
        self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.definesPresentationContext = YES;
    
    UIBarButtonItem *addProjectButtonBar;
    
    if ( ![_document entityBatchCreationAllowed] ) {
        addProjectButtonBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newEntity)];
    } else {
        addProjectButtonBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showBatchEntityPopover:forEvent:)];
    }
    
    editModeButtonBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditMode)];
    self.navigationItem.rightBarButtonItems = @[addProjectButtonBar, editModeButtonBar];
    
    deleteEntitiesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeEntities)];
    deleteEntitiesButton.tintColor = [UIColor redColor];
    
    selectedCount = [[UILabel alloc] initWithFrame:CGRectMake(37,7,250,35)];
    selectedCount.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    selectedCount.backgroundColor = [UIColor clearColor];
    selectedCount.textColor = [UIColor whiteColor];
    selectedCount.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *selectedCountWrapper = [[UIBarButtonItem alloc] initWithCustomView:selectedCount];
    
    toolbarItems = @[deleteEntitiesButton, selectedCountWrapper];
    
    [self setToolbarItems:toolbarItems animated:YES];
    
    self.navigationItem.title = [_document plural];
    [self updateCategories];
    [self.tableView reloadData];
    [self updateButtons];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
}

- (NSArray *)entities {
    
    Project *project = [NSObject currentProject];
    
    NSSet *entities = (NSSet *)[project valueForKey:[_document projectRelationshipKeyName]];
    
    if (entities) {
        return [entities allObjects];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self categoriesExcludeEmpty:YES] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    EntityCategory * category = [self categoryForSection:section excludeEmpty:YES];

    return [category.entities count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    EntityCategory * category = [self categoryForSection:section excludeEmpty:YES];
    
    if (category != nil) {
        return category.title;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        JTTransformableTableViewCell *cell = [[[_document entityRowClass] alloc] initWithStyle:[_document entityRowStyle] reuseIdentifier:@"cell"];
    
        if ( ![placeholderIndexPath isEqual:indexPath] ) {
            EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
            
            id entity = category.entities[ indexPath.row ];
            
            [_document updateRow:cell ForEntity:entity];
        } else {
            [_document updateRowWithPlaceholder:cell];
        }
    
        return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];

        id entity = category.entities[ indexPath.row ];
        
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete \"%@\"?", [_document titleForEntity:entity]];
        
        MBAlertView *alert = [MBAlertView alertWithBody:message cancelTitle:@"No" cancelBlock:nil];
        [alert addButtonWithText:@"Delete" type:MBAlertViewItemTypeDestructive block:^{
                
                NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
                
                [managedObjectContext deleteObject:entity];
                
                NSError *error;
                
                if(![managedObjectContext save:&error]){
                    NSLog(@"Error deleting entity.");
                    
                    [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
                } else {
                    NSLog(@"Entity deleted.");
                    
                    [self syncTableView];
                    [self updateButtons];
                    
                }
            
        }];
        [alert addToDisplayQueue];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.editing) {
        [self updateToolbar];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
        
        [self editEntity: category.entities[indexPath.row] ];
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    editModeButtonBar.enabled = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    editModeButtonBar.enabled = YES;
}

- (void)updateCategories {
    
    categories = nil;
    
    [self.document.entityCategories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EntityCategory *category = (EntityCategory *)obj;
        [category updateEntities:self.entities];
    }];
}

- (void)syncTableView {
    
    NSArray *oldCategories = [self categoriesExcludeEmpty:YES];
    NSMutableArray *itemsForEachCategory = [[NSMutableArray alloc] init];
    
    [itemsForEachCategory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        EntityCategory * category = (EntityCategory *)obj;
        
        [itemsForEachCategory addObject:category.entities];
    }];
    
    [self updateCategories];
    
    NSArray *newCategories = [self categoriesExcludeEmpty:YES];
    
    [self.tableView beginUpdates];
    
    //Deletes / Updates
    [oldCategories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EntityCategory * oldCategory = (EntityCategory *)obj;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
        
        if ( [newCategories indexOfObject:oldCategory] == NSNotFound ) {
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }];
            
    //Inserts
    [newCategories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EntityCategory * newCategory = (EntityCategory *)obj;
        
        if ( [oldCategories indexOfObject:newCategory] == NSNotFound ) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        }
            
    }];

    [self.tableView endUpdates];
    
    [self updateButtons];
}

- (void)newEntity {
    Entity * entity = [_document newEntity];
    [self.navigationController pushViewController:[_document viewControllerForEditingEntity:entity] animated:YES];
    [self updateToolbar];
}

- (void)toggleEditMode {
    self.tableView.allowsMultipleSelectionDuringEditing = !self.editing;
    
    [self.navigationController setToolbarHidden:self.editing animated:YES];
    [self setEditing:!self.editing animated:YES];
    
    [self updateToolbar];
}

- (void)updateButtons{
    if (self.tableView.numberOfSections <= 0) {
        self.editButtonItem.enabled = NO;
    } else {
        self.editButtonItem.enabled = YES;
    }
}

//TODO: Add Animated Trashcan
- (void)updateToolbar {
    int noSelected = [self.tableView.indexPathsForSelectedRows count];
    
    if (noSelected == 0){
        deleteEntitiesButton.enabled = NO;
    } else {
        deleteEntitiesButton.enabled = YES;
    }
    
    selectedCount.text = [NSString stringWithFormat:@"%i of %i selected", noSelected, [self.entities count]];
}

- (void)removeEntities {
    
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete these %@?", _document.plural];
    
    MBAlertView *alert = [MBAlertView alertWithBody:message cancelTitle:@"No" cancelBlock:nil];
    [alert addButtonWithText:@"Delete" type:MBAlertViewItemTypeDestructive block:^{
        
        
        NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
        NSArray *rowsToDelete = [self.tableView indexPathsForSelectedRows];
        
        [rowsToDelete enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            EntityCategory *category = [self categoryForSection:indexPath.section excludeEmpty:YES];
            
            [managedObjectContext deleteObject:category.entities[indexPath.row]];
        }];
        
        
        NSError *error;
        
        if(![managedObjectContext save:&error]){
            NSLog(@"Error deleting entities.");
            
            [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
        } else {
            NSLog(@"Entities deleted.");
            
            [self updateToolbar];
            [self syncTableView];
            [self updateButtons];
            
            if (self.tableView.numberOfSections <= 0) {
                [self toggleEditMode];
            }
        }
    }];
    [alert addToDisplayQueue];
   
}

- (void)showBatchEntityPopover:(id)sender forEvent:(UIEvent*)event {
    
    BatchNumberPickerViewController *batchNumberPickerViewController = [[BatchNumberPickerViewController alloc] init];
    batchNumberPickerViewController.document = _document;
    batchNumberPickerViewController.addBlock = ^(int value){
        
        //TODO: Use this concurrent code
        /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_apply(value, queue, ^(size_t idx) {
            [_document newEntity];
        });*/
        
        for (int i = 0; i < value; i++) {
            [_document newEntity];
        }
        [popoverController dismissPopoverAnimated:YES];
        [self syncTableView];
    };
    batchNumberPickerViewController.cancelBlock = ^(){
        [popoverController dismissPopoverAnimated:YES];
    };
    
    UINavigationController * navigationController =[[UINavigationController alloc] initWithRootViewController:batchNumberPickerViewController];
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:navigationController];
    
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];

}

-(void)editEntity:(id)entity {
    [self.navigationController pushViewController:[_document viewControllerForEditingEntity:entity] animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view.superview isKindOfClass:[UIToolbar class]]) {
        NSLog(@"Long Press Recognized, entering batch add mode.");
        return YES;
    }
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if (popoverController){
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (NSArray *)categoriesExcludeEmpty:(bool)exclude {
    
    if (categories) {
        return categories;
    }
    
    categories = [self.document entityCategories];
    
    if ( exclude ) {
        NSPredicate *categoryPredicate= [NSPredicate predicateWithFormat:@"entities.@count > 0"];
        
        categories = [categories filteredArrayUsingPredicate:categoryPredicate];
    }
    
    return categories;
}

- (EntityCategory *)categoryForSection:(int)section excludeEmpty:(bool)exclude {
    
    [self categoriesExcludeEmpty:exclude];
    
    if (categories.count > 0) {
        return categories[section];
    } else {
        return nil;
    }
    
}

- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditing) {
        return nil;
    }
    
    EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
    
    if (!category) {
        category = [_document defaultCategory];
    }
    
    return ([category canMoveEntityAtIndex:indexPath.row]) ? indexPath : nil ;
}

- (CGFloat)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer heightForCommittingRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
    
    //Handle empty documents
    if (!category) {
        category = [_document defaultCategory];
        [category addEntityAtIndex:indexPath.row];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        [self updateCategories];
    } else {
        [category addEntityAtIndex:indexPath.row];
    }
    
}

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditing) {
        return NO;
    }
    
    EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
    
    return [category canMoveEntityAtIndex:indexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    placeholderIndexPath = indexPath;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    placeholderIndexPath = destinationIndexPath;
    
    EntityCategory * sourceCategory = [self categoryForSection:sourceIndexPath.section excludeEmpty:YES];
    EntityCategory * destinationCategory = [self categoryForSection:destinationIndexPath.section excludeEmpty:YES];
    
    id entity = [sourceCategory moveEntityFromIndex:sourceIndexPath.row];
    [destinationCategory moveEntity:entity toIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    placeholderIndexPath = nil;
    [self syncTableView];
    [self saveProject];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
     EntityCategory * category = [self categoryForSection:indexPath.section excludeEmpty:YES];
    [category removeEntitiyFromIndex:indexPath.row];
}

- (void)saveProject {
    NSManagedObjectContext *managedObjectContext = [(PPAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSError *error;
    if(![managedObjectContext save:&error]){
        NSLog(@"Error saving project.");
        [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
    } else {
        NSLog(@"Project saved.");
    }
}


@end
