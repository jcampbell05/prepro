//
//  CrewDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CrewDocument.h"
#import "EntityCategory.h"
#import "EntityManagerViewController.h"
#import "Crew.h"

@implementation CrewDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Crew"];
}

- (NSString *)single {
    return @"Crew";
}

- (NSString *)projectRelationshipKeyName {
    return @"crew";
}

- (Class)entityClass {
    return [Crew class];
}

- (NSString *)titleForEntity:(id)entity {
    Crew *crewMember = (Crew *)entity;
    return crewMember.name;
}

- (UITableViewCellStyle)entityRowStyle {
    return UITableViewCellStyleSubtitle;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Crew *crewMember = (Crew *)entity;
    cell.textLabel.text = crewMember.jobRole;
    cell.detailTextLabel.text = crewMember.name;
    cell.imageView.image = [UIImage imageWithData:crewMember.photo];
}

- (void)loadEntityCategories {
    
    QRootElement *bindingData = (QRootElement *)[self bindingData];
    QRadioElement *radioElement = (QRadioElement *)[bindingData elementWithKey:@"department"];
    
    NSArray *departments = [radioElement items];
    __block NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    [departments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *departmentName = (NSString *)obj;
        
        EntityCategory *category = [EntityCategory alloc];
        category.title = departmentName;
        
        category.updateEntitiesBlock = ^ (NSArray * entities) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.department = %@", departmentName];
            return [entities filteredArrayUsingPredicate:predicate];
        };
        
        category.canAddBlock = ^ (int index) {
            return YES;
        };
        
        category.canMoveBlock = ^ (int index) {
            return YES;
        };
        
        category.addBlock = ^ (int index) {
            Crew *newCrew = [self newEntity];
            newCrew.department = departmentName;
            
            return newCrew;
        };
        
        category.moveToBlock = ^ (int index, id entity) {
            Crew *crew = (Crew *)entity;
            crew.department = departmentName;
            
            return crew;
        };
        
        NSLog(@"Adding Department Category: %@", departmentName);
        
        [categories addObject:category];
    }];
    
    self.entityCategories = categories;
}

@end
