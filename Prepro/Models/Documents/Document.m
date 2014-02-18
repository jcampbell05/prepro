//
//  Document.m
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Document.h"
#import "EntityManagerViewController.h"
#import "MBAlertView.h"
#import "Entity.h"

@implementation Document

- (bool)comingSoon {
    return NO;
}

- (UIImage *)icon {
    return nil;
}

- (NSString *)single {
    return nil;
}

- (NSString *)plural {
    return [self single];
}

- (NSArray *)entityCategories {
    if (!entityCategories) {
        entityCategories = [self loadEntityCategories];
    }
    
    return entityCategories;
}

- (EntityCategory *)defaultCategory {
    return [[EntityCategory alloc] init];
}

- (NSArray *)loadEntityCategories {
    return @[ [self defaultCategory] ];
}

- (UIViewController *)viewControllerForManaging {
    EntityManagerViewController *entityManagerViewController = [[EntityManagerViewController alloc] init];
    entityManagerViewController.document = self;
    return entityManagerViewController;
}

- (NSString *)projectRelationshipKeyName {
    return nil;
}

- (id)newEntity {
    return [[self entityClass] createNew];
}

- (Class)entityClass {
    return nil;
}

- (Class)entityRowClass {
    return [JTTransformableTableViewCell class];
}

- (bool)entityBatchCreationAllowed {
    return NO;
}

- (UITableViewCellStyle)entityRowStyle {
    return UITableViewCellStyleDefault;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    return;
}

- (void)updateRowWithPlaceholder:(UITableViewCell *)cell {
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
}

- (id)bindingData {
    return [[QRootElement alloc] initWithJSONFile: NSStringFromClass([self class]) ];
}

- (NSString *)titleForEntity:(id)entity {
    return @"";
}


//TODO: Switch to new Form System - This is important
- (id)viewControllerForEditingEntity:(id)entity {
    
    QRootElement  *root = (QRootElement *)[self bindingData];
    [root bindToObject: entity];
    
    QuickDialogController *quickDialogController = [QuickDialogController controllerForRoot:root];
    
    quickDialogController.willDisappearCallback = ^(){
        
        [root fetchValueIntoObject:entity];
        
        NSLog(@"Entity: %@", [entity description]);
        
        //Tell entity we are about to save it so it can do some last minute processing
        [entity onSave:self];
        
        NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
     
        NSError *error;
        if(![managedObjectContext save:&error]){
            NSLog(@"Error saving Project.");
            [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
        } else {
            NSLog(@"Project saved.");
        }
    };

    return quickDialogController;
}

@end
