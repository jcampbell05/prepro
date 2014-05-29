//
//  Document.m
//  Prepro
//
//  Created by James Campbell on 04/05/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "Document.h"
#import "EntityManagerViewController.h"
#import "ALFSAlert.h"
#import "Entity.h"
#import "EntityCategory.h"
#import "PPQuickDialogController.h"

@implementation Document

- (bool)comingSoon {
    return NO;
}

- (bool)decodeEnabled {
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
    if ( !_entityCategories ) {
        [self loadEntityCategories];
    }
    
    return _entityCategories;
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

- (NSString *)titleForEntity:(id)entity {
    return @"";
}

- (id)viewControllerForEditingEntity:(id)entity {
    
    PPQuickDialogController *quickDialogController = (PPQuickDialogController *)[[PPQuickDialogController alloc] initWithEntity:entity];
    
    __weak PPQuickDialogController * weakQuickDialogController = quickDialogController;
    
    quickDialogController.willDisappearCallback = ^(){
        
        [weakQuickDialogController.root fetchValueIntoObject:entity];
        [entity onSave:self];
    };

    return quickDialogController;
}

#pragma mark Entity Category

- (void)loadDefaultEntityCategory {
    
    self.defaultEntityCategory = [[EntityCategory alloc] init];
}

- (void)loadEntityCategories {
    
    if ( !_defaultEntityCategory ) {
        [self loadDefaultEntityCategory];
    }
    
    self.entityCategories = @[ self.defaultEntityCategory ];
}

#pragma mark - deprecated
- (id)bindingData {
    
    QRootElement  *root = [[QRootElement alloc] initWithJSONFile: NSStringFromClass([self entityClass]) ];
    
    return root;
}

@end
