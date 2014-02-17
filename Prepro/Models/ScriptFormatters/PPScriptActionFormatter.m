//
//  PPScriptActionFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptActionFormatter.h"
#import "PPScriptActionSection.h"

@implementation PPScriptActionFormatter

- (QRootElement *)visualEditForm {
    
    QRootElement * rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Action";
    
    QSection * defaultSection = [[QSection alloc] initWithTitle:nil];
    
    QMultilineElement * actionText = [[QMultilineElement alloc] initWithKey:@"text"];
    actionText.title = @"Text";
    actionText.bind = @"textValue:text";
    
    [defaultSection addElement: actionText];
    
    [rootElement addSection: defaultSection];
    
    return rootElement;
}

- (PPScriptSection *)scriptSectionForFormat {
    return [[PPScriptActionSection alloc] init];
}

- (NSString *)title {
    return @"Action";
}

@end
