//
//  PPScriptParentheticalFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptParentheticalFormatter.h"
#import "PPScriptParentheticalSection.h"

@implementation PPScriptParentheticalFormatter

- (QRootElement *)visualEditForm {
    
    QRootElement * rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Parenthetical";
    
    QSection * defaultSection = [[QSection alloc] initWithTitle:nil];
    
    QMultilineElement * parentheticalText = [[QMultilineElement alloc] initWithKey:@"text"];
    parentheticalText.title = @"Text";
    parentheticalText.bind = @"textValue:text";
    
    [defaultSection addElement: parentheticalText];
    
    [rootElement addSection: defaultSection];
    
    return rootElement;
}

- (PPScriptSection *)scriptSectionForFormat {
    return [[PPScriptParentheticalSection alloc] init];
}

- (NSString *)title {
    return @"Parenthetical";
}

@end
