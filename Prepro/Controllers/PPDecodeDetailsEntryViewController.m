//
//  PPDecodeDetailsEntryViewController.m
//  Prepro
//
//  Created by James Campbell on 04/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPDecodeDetailsEntryViewController.h"
#import "PPHireViewController.h"

@interface PPDecodeDetailsEntryViewController ()

@property (nonatomic, strong) QRootElement * rootElement;
@property (nonatomic, strong) QEntryElement * firstName;
@property (nonatomic, strong) QEntryElement * lastName;
@property (nonatomic, strong) QEntryElement * address;
@property (nonatomic, strong) QEntryElement * city;
@property (nonatomic, strong) QEntryElement * county;
@property (nonatomic, strong) QEntryElement * phone;
@property (nonatomic, strong) QEntryElement * email;

@end

@implementation PPDecodeDetailsEntryViewController

- (instancetype)init {
    
    self.rootElement = [[QRootElement alloc] init];
    self.rootElement.title = @"Decode Hire";
    
    QSection * section = [[QSection alloc] initWithTitle:@"Enter Your Details"];
    
    [self.rootElement addSection: section];
    
    self.firstName = [[QEntryElement alloc] initWithTitle:@"First Name" Value:nil];
    self.firstName.key = @"firstName";
    self.firstName.bind = @"textValue:decodeFirstName";
    [section addElement: self.firstName];
    
    self.lastName = [[QEntryElement alloc] initWithTitle:@"Last Name" Value:nil];
    self.lastName.key = @"lastName";
    self.lastName.bind = @"textValue:decodeLastName";
    [section addElement: self.lastName];
    
    self.address = [[QEntryElement alloc] initWithTitle:@"Address" Value:nil];
    self.address.key = @"address";
    self.address.bind = @"textValue:decodeAddress";
    [section addElement: self.address];
    
    self.city = [[QEntryElement alloc] initWithTitle:@"City" Value:nil];
    self.city.key = @"city";
    self.city.bind = @"textValue:decodeCity";
    [section addElement: self.city];
    
    self.county = [[QEntryElement alloc] initWithTitle:@"County" Value:nil];
    self.county.key = @"county";
    self.county.bind = @"textValue:decodeCounty";
    [section addElement: self.county];
    
    self.phone = [[QEntryElement alloc] initWithTitle:@"Phone" Value:nil];
    self.phone.key = @"phone";
    self.phone.bind = @"textValue:decodePhone";
    [section addElement: self.phone];
    
    self.email = [[QEntryElement alloc] initWithTitle:@"Email" Value:nil];
    self.email.key = @"email";
    self.email.bind = @"textValue:decodeEmail";
    [section addElement: self.email];
    
    if ( self = [super initWithRoot: self.rootElement] ) {

        [self.navigationController setNavigationBarHidden: NO];
        
        UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    
    return self;
}

- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    
    if (self.firstName.textValue.length > 0 && self.lastName.textValue.length > 0 && self.address.textValue.length > 0 && self.city.textValue.length > 0 && self.county.textValue.length > 0 && self.phone.textValue.length > 0 && self.email.textValue.length > 0) {
    
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

        [defaults setObject:self.firstName.textValue forKey:@"decodeFirstName"];
        [defaults setObject:self.lastName.textValue forKey:@"decodeLastName"];
        [defaults setObject:self.address.textValue forKey:@"decodeAddress"];
        [defaults setObject:self.city.textValue forKey:@"decodeCity"];
        [defaults setObject:self.county.textValue forKey:@"decodeCounty"];
        [defaults setObject:self.phone.textValue forKey:@"decodePhone"];
        [defaults setObject:self.email.textValue forKey:@"decodeEmail"];
        
        [defaults setBool:YES forKey:@"decodeShownDetailsEntryScreen"];
        
        [defaults synchronize];
        
        PPHireViewController * hireViewController = [[PPHireViewController alloc] init];
        hireViewController.items = self.items;
        hireViewController.parentVC = self.parentVC;    
        
        [self.navigationController pushViewController:hireViewController animated:YES];
        
    }
}

@end
