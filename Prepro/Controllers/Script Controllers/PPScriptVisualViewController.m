//
//  PPScriptVisualViewController.m
//  Prepro
//
//  Created by James Campbell on 11/02/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPScriptVisualViewController.h"
#import "PPScriptSceneFormatter.h"
#import "PPScriptActionFormatter.h"
#import "PPScriptCharacterFormatter.h"
#import "PPScriptDialogueFormatter.h"
#import "PPScriptParentheticalFormatter.h"
#import "FNScript.h"
#import "FountainWriter.h"
#import "PPPreproScript.h"

@interface PPScriptVisualViewController ()

- (void)loadFormatters;
- (void)loadFormatViewController;
- (void)save;

@end

@implementation PPScriptVisualViewController

#pragma mark UIViewController Lifecycle

- (id)init {
    
    if ( self = [super init] ) {
        
        [self loadFormatters];
        [self loadFormatViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    FNScript * fountainScript = [[FNScript alloc] initWithString: _script.content];
    
    PPPreproScript * preproScript = [[PPPreproScript alloc] initWithScript: fountainScript andFormatters: _formatters];
    
    _sections = [preproScript sections];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self save];
}

#pragma mark Implementation

- (void)loadFormatters {
    
    _formatters = @[
        [[PPScriptSceneFormatter alloc] init],
        [[PPScriptActionFormatter alloc] init],
        [[PPScriptCharacterFormatter alloc] init],
        [[PPScriptDialogueFormatter alloc] init],
        [[PPScriptParentheticalFormatter alloc] init]
    ];
}

- (void)loadFormatViewController {
    _formatViewController = [[PPScriptFormatViewController alloc] initWithFormatters: _formatters andDelegate: self];
}

- (void)save {
    
    NSMutableArray * elements =[[NSMutableArray alloc] init];
    
    [_sections enumerateObjectsUsingBlock:^(PPScriptSection * section, NSUInteger idx, BOOL *stop) {
        [elements addObject: [section scriptElement]];
    }];
    
    FNScript * fountainScript = [[FNScript alloc] init];
    fountainScript.elements = [elements copy];
    
    _script.content = [FountainWriter bodyFromScript: fountainScript];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sections.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ( [placeholderIndexPath isEqual:indexPath] ) {
        
        static NSString * identifier = @"placeholder";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: identifier];
            
        }
        
        return cell;

    } else if ( indexPath.row < _sections.count ){
        
        PPScriptSection * section = _sections[ indexPath.row ];
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: [section cellIdentifier]];
        
        if (!cell) {

            cell = [[[section cellClass] alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: [section cellIdentifier]];
            
        }
        
        [section updateCell: cell];
        
        return cell;
        
    } else {
        
        static NSString * identifier = @"cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: identifier];

        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: identifier];
            
        }
        
        cell.textLabel.text = @"+ Add";
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == _sections.count ) {
        [_formatViewController addScriptSection];
    } else {
        [_formatViewController editScriptSection: _sections[ indexPath.row ] ];
    }
    
    [self presentViewController: _formatViewController animated: YES completion: nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_sections removeObjectAtIndex: indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
        [self save];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row != _sections.count);
}

#pragma mark PPScriptFormatViewControllerDelegate

- (void)scriptFormatSectionAdded:(PPScriptSection *)section {
    
    [_sections addObject: section];
    [self save];
}

- (void)scriptFormatSectionEdited: (PPScriptSection *)section {
    [self.tableView reloadData];
    [self save];
}

#pragma mark JTTableViewGestureAddingRowDelegate + JTTableViewGestureMoveRowDelegate


- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer heightForCommittingRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [_sections moveObjectFromIndex:sourceIndexPath.row toIndex: destinationIndexPath.row];
    
    placeholderIndexPath = destinationIndexPath;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    placeholderIndexPath = nil;
    
    [self.tableView reloadData];
    [self save];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
