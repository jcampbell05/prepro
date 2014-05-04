//
//  PPProductViewController.m
//  Prepro
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//
// Move to Magical Record

#import "PPProductViewController.h"
#import "Equipment.h"
#import "CHCSVParser.h"
#import "NSObject+AppDelegate.h"
#import "ALFSAlert.h"
#import "PPProduct.h"

@interface PPProductViewController ()

@property (strong, nonatomic) NSArray * items;

- (void)setupSearchBar;
- (void)loadItems;

@end

@implementation PPProductViewController


- (id)initWithEquipment:(Equipment *)equipment {

    if (self  = [super initWithStyle: UITableViewStylePlain]) {
        
        self.equipment = equipment;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadItems];
}

- (void)loadItems {
    
    NSString * csvPath = [[NSBundle mainBundle] pathForResource:@"Products" ofType:@"csv"];
    
    NSMutableArray * csvData = [NSMutableArray arrayWithContentsOfCSVFile:csvPath];
    [csvData removeObjectAtIndex: 0];
    
    NSMutableArray * newItems = [[NSMutableArray alloc] init];
    
    for (NSArray * row in csvData) {
        
        PPProduct * newProduct = [[PPProduct alloc] init];
        
        newProduct.name = row[0];
        newProduct.type = row[1];
        newProduct.subtype = row[2];
        newProduct.price = row[3];
        newProduct.priceType = row[4];
        
        [newItems addObject: newProduct];
    }
    
    NSPredicate * productFilter = [NSPredicate predicateWithFormat:@"type == %@", self.equipment.type];
    
    self.items = [newItems filteredArrayUsingPredicate: productFilter];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tabeView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if ( cell == nil ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
        
    }
    
    PPProduct * item = self.items[ indexPath.row ];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item priceAsString];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Product Selected");
    
    PPProduct * item = self.items[ indexPath.row ];
    
    self.equipment.product = item.name;
    self.equipment.name = item.name;
    self.equipment.price = @([item.price floatValue]);
    self.equipment.priceRate = item.priceType;
    
    NSError *error;
    
    NSLog(@"Entity: %@", self.equipment);
    
    if( ![self.equipment save:&error] ) {
        NSLog(@"Error saving equipment.");
        
        ALFSAlert * alert = [[ALFSAlert alloc] initInViewController: self.parentViewController];
        
        [alert showAlertWithMessage: error.description];
        [alert addButtonWithText:@"Continue" forType:ALFSAlertButtonTypeNormal onTap:^{
            [alert removeAlert];
        }];
        
    } else {
        NSLog(@"Equipment Saved.");
    }
    
    
    //TODO: Remove the need for this workaround.
    QEntryElement * nameElement = (QEntryElement *)[self.quickTableView.root elementWithKey:@"name"];
    nameElement.textValue = item.name;
    
    QDecimalElement * priceElement = (QDecimalElement *)[self.quickTableView.root elementWithKey:@"price"];
    priceElement.floatValue = @([item.price floatValue]);
    
    [self.quickTableView reloadCellForElements:nameElement, priceElement, nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated: YES];
}

@end
