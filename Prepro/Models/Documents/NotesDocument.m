//
//  NotesDocument.m
//  Prepro
//
//  Created by James Campbell on 21/04/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "NotesDocument.h"
#import "Note.h"
#import "FullScreenTextViewEditorViewController.h"

@implementation NotesDocument

- (UIImage *) icon {
    return [UIImage imageNamed:@"Notes"];
}

- (NSString *)single {
    return @"Note";
}

- (NSString *)plural {
    return @"Notes";
}

- (NSString *)projectRelationshipKeyName {
    return @"notes";
}

- (Class)entityClass {
    return [Note class];
}

- (NSString *)titleForEntity:(id)entity {
    Note *note = (Note *)entity;
    return note.contents;
}

- (UITableViewCellStyle)entityRowStyle {
    return UITableViewCellStyleSubtitle;
}

- (void)updateRow:(UITableViewCell *)cell ForEntity:(id)entity {
    
    Note *note = (Note *)entity;
    cell.textLabel.text = note.contents;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    cell.detailTextLabel.text = [formatter stringFromDate:note.created];
}

- (id)viewControllerForEditingEntity:(id)entity {
    
    FullScreenTextViewEditorViewController *fullscreenScreenTextViewEditorViewController = [[FullScreenTextViewEditorViewController alloc] init];

    
    fullscreenScreenTextViewEditorViewController.document = self;
    fullscreenScreenTextViewEditorViewController.entity = entity;
    
    fullscreenScreenTextViewEditorViewController._getEntityTextBlock = ^ NSString * (id entity) {
        Note *note = (Note *)entity;
        return note.contents;
    };
    
    fullscreenScreenTextViewEditorViewController._setEntityTextBlock = ^ void (id entity, NSString * text) {
        Note *note = (Note *)entity;
        note.contents = text;
    };
    
    return fullscreenScreenTextViewEditorViewController;
    
}


@end
