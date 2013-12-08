//
//  EntityCategory.m
//  Prepro
//
//  Created by James Campbell on 22/09/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "EntityCategory.h"
#import "Entity.h"
#import "NSObject+AppDelegate.h"

@implementation EntityCategory

- (void)updateEntities:(NSArray *) entities {
    _entities = [(_updateEntitiesBlock) ? _updateEntitiesBlock(entities) : entities mutableCopy];
}

- (BOOL)canAddEntityAtIndex:(int) index {
    return ( _canAddBlock && _canAddBlock( index ) );
}

- (BOOL)canMoveEntityAtIndex:(int) index {
    return ( _canMoveBlock && _canMoveBlock( index ) );
}

- (void)addEntityAtIndex:(int) index {
   id entity = _addBlock(index);
   
    [_entities insertObject:entity atIndex:index];
}


- (void)moveEntity:(id)entity toIndex:(int) index {
    [_entities insertObject:entity atIndex:index];
    
    if (_moveToBlock) {
        entity = _moveToBlock(index, entity);
    }
}

- (id)moveEntityFromIndex:(int) index {
    id entity = [_entities objectAtIndex:index];
    
    if (_moveFromBlock) {
        _moveFromBlock(index, entity);
    }
    
    [_entities removeObjectAtIndex:index];
    
    return entity;
}

- (void)removeEntitiyFromIndex:(int) index {
    
    NSManagedObjectContext *managedObjectContext = [NSObject managedObjectContext];
    
    Entity * entity = [_entities objectAtIndex:index];
    [_entities removeObjectAtIndex:index];
    
    [managedObjectContext deleteObject:entity];
    
    
    //TODO: Reduce need to litter code with this stuff.
    
    NSError *error;
    
    if(![managedObjectContext save:&error]){
        NSLog(@"Error deleting entity.");
    } else {
        NSLog(@"Entity deleted.");
    }

    
}

@end
