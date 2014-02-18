//
//  PPPreproScript.m
//  Prepro
//
//  Created by James Campbell on 17/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPPreproScript.h"
#import "PPScriptSceneSection.h"
#import "PPScriptSceneFormatter.h"
#import "FNElement.h"

@interface PPPreproScript ()

- (PPScriptSection *)sectionForElement:(FNElement *)element;

@end

@implementation PPPreproScript

- (id)initWithScript:(FNScript *)script andFormatters:(NSArray *)formatters;
{
    
    if ( self = [super init] ) {
        
        _script = script;
        _formatters = formatters;
    }
    
    return self;
}

- (NSMutableArray *)sections {
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    [_script.elements enumerateObjectsUsingBlock:^(FNElement * element, NSUInteger idx, BOOL *stop) {
        
        PPScriptSection * section = [self sectionForElement: element];
        
        if (section) {
            [result addObject: section];
        }
    }];
    
    return result;
}

- (PPScriptSection *)sectionForElement:(FNElement *)element {
    
    __block PPScriptSection * section;
    
    [_formatters enumerateObjectsUsingBlock:^(PPScriptSceneFormatter * formatter, NSUInteger idx, BOOL *stop) {
        
        section = [formatter scriptSectionForFormat];
        
        if ( [element.elementType isEqualToString: [section elementType]] ) {
            
            [section processElementText: element.elementText];
            *stop = YES;
        } else {
            
            section = nil;
        }
                                     
    }];
    
    return section;
}

@end
