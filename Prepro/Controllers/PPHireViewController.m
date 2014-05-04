//
//  PPHireViewController.m
//  Prepro
//
//  Created by James Campbell on 26/03/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPHireViewController.h"
#import "ALFSAlert.h"
#import "Equipment.h"
#import <MessageUI/MessageUI.h>

@interface PPHireViewController ()

@property (nonatomic, strong) QRootElement * rootElement;

@end

@implementation PPHireViewController

- (instancetype)init {
    
    self.rootElement = [[QRootElement alloc] init];
    self.rootElement.title = @"Decode Hire";
    
    QSection * section = [[QSection alloc] initWithTitle:@"What Dates Do You Need This For ?"];
    
    [self.rootElement addSection: section];
    
    QDateTimeInlineElement * startDate = [[QDateTimeInlineElement alloc] initWithTitle:@"Start Date" date:[NSDate new] andMode:UIDatePickerModeDateAndTime];
    startDate.key = @"startDate";
    startDate.bind = @"textValue:startDate";
    
    [section addElement: startDate];
    
    QDateTimeInlineElement * endDate = [[QDateTimeInlineElement alloc] initWithTitle:@"Start Date" date:[NSDate new] andMode:UIDatePickerModeDateAndTime];
    endDate.key = @"endDate";
    endDate.bind = @"textValue:endDate";
    
    [section addElement: endDate];
    
    QEntryElement * notes = [[QEntryElement alloc] initWithTitle:@"Notes / Comments" Value:nil];
    notes.key = @"notes";
    notes.bind = @"textValue:notes";

    [section addElement: notes];
    
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
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    
    [self.rootElement fetchValueIntoObject: data];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSMutableString * body = [[NSMutableString alloc] init];
        
        [body appendString:@"--------------------------\n"];
        [body appendString:@"Details Of Quoted Products\n"];
        [body appendString:@"--------------------------\n"];
        
        for (Equipment * equipment in self.items) {
            
            if ( equipment.product && equipment.product.length > 0 ) {
                
                [body appendString:@"Product Name: "];
                [body appendString:equipment.product];
                [body appendString:@"\n"];
                
                [body appendString:@"Quantity "];
                [body appendString:equipment.quantity.stringValue];
                [body appendString:@"\n\n"];
                
            }
            
        }
        
        [body appendString:@"--------------------------\n"];
        [body appendString:@"     Customer Details     \n"];
        [body appendString:@"--------------------------\n"];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        
        NSLog(@"FN %@", [defaults stringForKey:@"decodeFirstName"]);
        NSLog(@"LN %@", [defaults stringForKey:@"decodeLastName"]);
        NSLog(@"Email %@", [defaults stringForKey:@"decodeEmail"]);
        NSLog(@"P %@", [defaults stringForKey:@"decodePhone"]);
        
        [body appendString:@"Name: "];
        [body appendString:[defaults stringForKey:@"decodeFirstName"]];
        [body appendString:@" "];
        [body appendString:[defaults stringForKey:@"decodeLastName"]];
        [body appendString:@"\n"];
        
        [body appendString:@"Email: "];
        [body appendString:[defaults stringForKey:@"decodeEmail"]];
        [body appendString:@"\n"];
        
        [body appendString:@"Phone: "];
        [body appendString:[defaults stringForKey:@"decodePhone"]];
        [body appendString:@"\n"];
        
        [body appendString:@"Address: "];
        [body appendString:[defaults stringForKey:@"decodeAddress"]];
        [body appendString:@"\n"];
        
        [body appendString:@"City: "];
        [body appendString:[defaults stringForKey:@"decodeCity"]];
        [body appendString:@"\n"];
        
        [body appendString:@"County: "];
        [body appendString:[defaults stringForKey:@"decodeCounty"]];
        [body appendString:@"\n"];
        
        QDateTimeInlineElement * startDate = (QDateTimeInlineElement *)[self.rootElement elementWithKey:@"startDate"];
        
        QDateTimeInlineElement * endDate = (QDateTimeInlineElement *)[self.rootElement elementWithKey:@"endDate"];
        
        QEntryElement * notes = (QEntryElement *)[self.rootElement elementWithKey:@"notes"];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-YYYY h:mm a";
        
        [body appendString:@"Dates Required / Additional Comments: "];
        
        NSString * startDateString = [dateFormatter stringFromDate: startDate.dateValue];
        
        if (startDateString) {
            
            [body appendString: startDateString];
        }
        
        [body appendString:@" - "];
        
        NSString * endDateString = [dateFormatter stringFromDate: endDate.dateValue];
        
        if (endDateString) {
                [body appendString: endDateString];
        }
        
        [body appendString:@"\n"];
        
        if (notes.textValue) {
        
            [body appendString:notes.textValue];
            [body appendString:@"\n"];
            
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            MFMailComposeViewController * mailComposeViewController = [[MFMailComposeViewController alloc] init];
            mailComposeViewController.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self.parentVC;
            [mailComposeViewController setSubject:@"Decode Quote via Prepro"];
            [mailComposeViewController setToRecipients:@[ @"info@decodeuk.com" ]];
            [mailComposeViewController setMessageBody:body isHTML:NO];
            
            
            [self.parentVC presentViewController:mailComposeViewController animated:YES completion:nil];
            
        }];
        
        return;
    } else {

        ALFSAlert * alert = [[ALFSAlert alloc] initInViewController: self.parentViewController];
        
        [alert showAlertWithMessage: @"You need to setup email on your device before you can continue."];
        [alert addButtonWithText:@"Continue" forType:ALFSAlertButtonTypeNormal onTap:^{
            [alert removeAlert];
        }];

        
    }

}

@end
