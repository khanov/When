//
//  SKAddEventTableViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 12/25/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKAddEventTableViewController.h"

static NSInteger kNameCellIndex = 0;
static NSInteger kStartDatePickerIndex = 2;
static NSInteger kEndDatePickerIndex = 4;
static NSInteger kDatePickerCellHeight = 164;

@interface SKAddEventTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation SKAddEventTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDateLabels];
    [self setupDatePickers];
    [self signUpForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupDateLabels
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *now = [NSDate date];
    self.startsDateLabel.text = [self.dateFormatter stringFromDate:now];
    self.startsDateLabel.textColor = [self.tableView tintColor];
    
    self.endsDateLabel.text = nil;
    self.endsDateLabel.textColor = [self.tableView tintColor];
}

- (void)setupDatePickers
{
    self.startsDatePicker.hidden = YES;
    self.endsDatePicker.hidden = YES;
    self.endsDatePicker.minimumDate = [self.startsDatePicker date];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

# pragma mark - TableView Setup

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    // Set height = 0 for hidden date pickers
    if (indexPath.row == kStartDatePickerIndex) {
        height = self.startsDatePicker.isHidden ? 0 : kDatePickerCellHeight;
    } else if (indexPath.row == kEndDatePickerIndex) {
        height =  self.endsDatePicker.isHidden ? 0 : kDatePickerCellHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != kNameCellIndex) {
        [self.nameTextField resignFirstResponder];
    }
    
    if (indexPath.row == kStartDatePickerIndex - 1) {
        // Hide/show Start Date picker
        self.startsDatePicker.isHidden ? [self showCellForDatePicker:self.startsDatePicker] : [self hideCellForDatePicker:self.startsDatePicker];
        [self hideCellForDatePicker:self.endsDatePicker];
    } else if (indexPath.row == kEndDatePickerIndex - 1) {
        // Hide/show End Date picker
        [self hideCellForDatePicker:self.startsDatePicker];
        self.endsDatePicker.isHidden ? [self showCellForDatePicker:self.endsDatePicker] : [self hideCellForDatePicker:self.endsDatePicker];
    }
}

- (void)showCellForDatePicker:(UIDatePicker *)datePicker
{
    datePicker.hidden = NO;
    datePicker.alpha = 0.0f;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.38 animations:^{
        datePicker.alpha = 1.0f;
    }];
}


- (void)hideCellForDatePicker:(UIDatePicker *)datePicker
{
    datePicker.hidden = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         datePicker.hidden = YES;
                     }];
}

- (IBAction)pickerDateChanged:(UIDatePicker *)sender
{
    if (sender.tag == 0) {
        // Start Date Picker Changed
        self.startsDateLabel.text = [self.dateFormatter stringFromDate:sender.date];
        self.endsDatePicker.minimumDate = self.startsDatePicker.date;
    } else if (sender.tag == 1) {
        // End Date Picker Changed
        if (self.endsDateLabel.text.length == 0) {
            self.endsDateLabel.alpha = 0.0f;
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.endsDateLabel.alpha = 1.0f;
                             }];
        }
        self.endsDateLabel.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (IBAction)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButton:(id)sender
{
    if (self.nameTextField.text.length == 0) {
        NSString *title = @"Empty Name";
        NSString *message = @"Please give a name to the event.";
        NSString *cancelTitle = @"OK";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
        [alertView show];
    }
    else {
        SKEvent *newEvent = [[SKEvent alloc] initWithName:self.nameTextField.text
                                                startDate:self.startsDatePicker.date
                                                  endDate:self.endsDatePicker.date
                                               andDetails:nil];
        
        [self.delegate saveEventDetails:newEvent];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)keyboardWillShow
{
    !self.startsDatePicker.isHidden ? [self hideCellForDatePicker:self.startsDatePicker] : nil;
    !self.endsDatePicker.isHidden ? [self hideCellForDatePicker:self.endsDatePicker] : nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Show the firts date picker and hide the second one
    [self showCellForDatePicker:self.startsDatePicker];
    [self hideCellForDatePicker:self.endsDatePicker];
    [self.nameTextField resignFirstResponder];

    return YES;
}

@end
