//
//  CastAndCrewDocument.m
//  Prepro
//
//  Created by James Campbell on 25/03/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "CastDocument.h"
#import "Cast.h"
#import "EntityCategory.h"

@implementation CastDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Cast"];
}

- (NSString *)single {
    return @"Cast";
}

- (NSString *)projectRelationshipKeyName {
    return @"cast";
}

- (Class)entityClass {
    return [Cast class];
}

- (UITableViewCellStyle)entityRowStyle {
    return UITableViewCellStyleSubtitle;
}

- (NSString *)titleForEntity:(id)entity {
    Cast *castMember = (Cast *)entity;
    return castMember.name;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    Cast *castMember = (Cast *)entity;
    cell.textLabel.text = castMember.characterName;
    cell.detailTextLabel.text = castMember.name;
    cell.imageView.image = [UIImage imageWithData:castMember.photo];
}

- (void)loadEntityCategories {
    
    QRootElement *bindingData = (QRootElement *)[self bindingData];
    QRadioElement *radioElement = (QRadioElement *)[bindingData elementWithKey:@"roleType"];
    
    NSArray *departments = [radioElement items];
    __block NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    [departments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *roleType = (NSString *)obj;
        
        EntityCategory *category = [EntityCategory alloc];
        category.title = roleType;
        
        category.updateEntitiesBlock = ^ (NSArray * entities) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.roleType = %@", roleType];
            return [entities filteredArrayUsingPredicate:predicate];
        };
        
        category.canAddBlock = ^ (int index) {
            return YES;
        };
        
        category.canMoveBlock = ^ (int index) {
            return YES;
        };
        
        category.addBlock = ^ (int index) {
            Cast *newCast = [self newEntity];
            newCast.roleType = roleType;
            
            return newCast;
        };
        
        category.moveToBlock = ^ (int index, id entity) {
            Cast *cast = [self newEntity];
            cast.roleType = roleType;
            
            return cast;
        };
        
        NSLog(@"Adding Role Type Category: %@", roleType);
        
        [categories addObject:category];
    }];
    
    self.entityCategories = categories;
}

@end
