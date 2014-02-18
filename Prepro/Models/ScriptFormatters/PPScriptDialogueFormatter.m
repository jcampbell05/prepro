//
//  PPScriptDialogueFormatter.m
//  Prepro
//
//  Created by James Campbell on 15/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptDialogueFormatter.h"
#import "PPScriptDialogueSection.h"

@implementation PPScriptDialogueFormatter

- (QRootElement *)visualEditForm {
    
    QRootElement * rootElement = [[QRootElement alloc] init];
    rootElement.title = @"Dialogue";
    
    QSection * defaultSection = [[QSection alloc] initWithTitle:nil];
    
    QMultilineElement * dialogueText = [[QMultilineElement alloc] initWithKey:@"text"];
    dialogueText.title = @"Text";
    dialogueText.bind = @"textValue:text";
    
    [defaultSection addElement: dialogueText];
    
    [rootElement addSection: defaultSection];
    
    return rootElement;
}

- (PPScriptSection *)scriptSectionForFormat {
    return [[PPScriptDialogueSection alloc] init];
}

- (NSString *)title {
    return @"Dialogue";
}

@end
