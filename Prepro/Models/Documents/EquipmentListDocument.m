//
//  EquipmentListDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "EntityCategory.h"
#import "EquipmentListDocument.h"
#import "NSObject+AppDelegate.h"
#import "TDBadgedCell.h"
#import "Equipment.h"
#import "PPProductViewController.h"
#import "MBAlertView.h"

@implementation EquipmentListDocument

- (bool)decodeEnabled {
    return YES;
}

- (UIImage *) icon {
    return [UIImage imageNamed:@"Equipment"];
}

- (NSString *)single {
    return @"Equipment";
}

- (NSString *)projectRelationshipKeyName {
    return @"equipment";
}

- (Class)entityClass {
    return [Equipment class];
}

- (NSString *)titleForEntity:(id)entity {
    Equipment *equipment = (Equipment *)entity;
    return equipment.name;
}

- (Class)entityRowClass {
    return [TDBadgedCell class];
}

- (void)updateRow:(TDBadgedCell *)cell ForEntity:(id)entity {
    Equipment *equipment = (Equipment *)entity;
    cell.textLabel.text = equipment.name;
    cell.imageView.image = [UIImage imageWithData:equipment.photo];
    
    if ([equipment.quantity intValue] > 1) {
        cell.badgeString = [equipment.quantity stringValue];
    }
}
    
    //TODO: Switch to new Form System - This is important
- (id)viewControllerForEditingEntity:(Equipment *)entity {
    
    QuickDialogController *quickDialogController = [super viewControllerForEditingEntity:entity];
    
    QLabelElement * productElement = (QLabelElement *)[quickDialogController.root elementWithKey:@"product"];
    
    productElement.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    productElement.onSelected = ^() {
        
        //Remove and tidy up in 1.4.1 +
        NSError * error;
        
        if(![entity save:&error]){
            NSLog(@"Error saving equipment.");
            [[MBAlertView alertWithBody:error.description cancelTitle:@"Continue" cancelBlock:nil] addToDisplayQueue];
        } else {
            NSLog(@"Equipment Saved before showing Product Page.");
        }
    
        PPProductViewController * productViewController = [[PPProductViewController alloc] initWithEquipment: (Equipment *)entity];
        
        productViewController.quickTableView = quickDialogController.quickDialogTableView;
        
        [quickDialogController.navigationController pushViewController:productViewController animated:YES];
        
    };
    
    return quickDialogController;
}

- (void)loadEntityCategories {
    
    QRootElement *bindingData = (QRootElement *)[self bindingData];
    QRadioElement *radioElement = (QRadioElement *)[bindingData elementWithKey:@"type"];
    
    NSArray *types = [radioElement items];
    __block NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    [types enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *typeName = (NSString *)obj;
        
        EntityCategory *category = [EntityCategory alloc];
        category.title = typeName;
        
        category.updateEntitiesBlock = ^ (NSArray * entities) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.type = %@", typeName];
            return [entities filteredArrayUsingPredicate:predicate];
        };
        
        category.canAddBlock = ^ (int index) {
            return YES;
        };
        
        category.canMoveBlock = ^ (int index) {
            return YES;
        };
        
        category.addBlock = ^ (int index) {
            Equipment *newEquipment = [self newEntity];
            newEquipment.type = typeName;
            
            return newEquipment;
        };
        
        category.moveToBlock = ^ (int index, id entity) {
            Equipment *equipment = (Equipment *)entity;
            equipment.type = typeName;
            
            return equipment;
        };
        
        NSLog(@"Adding Type Category: %@", typeName);

        [categories addObject:category];
    }];
    
    self.entityCategories = categories;
}

@end
