//
//  SKAddEventTableViewController.h
//  Time Left
//
//  Created by Salavat Khanov on 12/25/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAddEventDelegate.h"

@interface SKAddEventTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *startsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endsDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startsDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endsDatePicker;
@property (weak, nonatomic) id<SKAddEventDelegate> delegate;

- (IBAction)pickerDateChanged:(UIDatePicker *)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@end
