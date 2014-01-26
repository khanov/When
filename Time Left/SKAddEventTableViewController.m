//
//  SKAddEventTableViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 12/25/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKAddEventTableViewController.h"

static NSInteger kTextFieldSection = 0;
static NSInteger kNameCellIndex = 0;
static NSInteger kDescriptionCellIndex = 1;

static NSInteger kDatePickerSection = 1;
static NSInteger kStartDatePickerIndex = 1;
static NSInteger kEndDatePickerIndex = 3;
static NSInteger kDatePickerCellHeight = 164;

static NSString *kEndsDateDefaultString = @"Choose...";
static NSString *kErrorEmptyNameTitle = @"Empty Name";
static NSString *kErrorEmptyNameMessage = @"Please give a name to the event.";
static NSString *kErrorEmptyNameCancel = @"OK";

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
    
    self.endsDateLabel.text = kEndsDateDefaultString;
    self.endsDateLabel.textColor = [self.tableView tintColor];
}

- (void)setupDatePickers
{
    self.startsDatePicker.hidden = YES;
    self.endsDatePicker.hidden = YES;
    self.endsDatePicker.minimumDate = [NSDate date];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

# pragma mark - TableView Setup

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    // Set height = 0 for hidden date pickers
    if (indexPath.section == kDatePickerSection && indexPath.row == kStartDatePickerIndex) {
        height = self.startsDatePicker.isHidden ? 0 : kDatePickerCellHeight;
    } else if (indexPath.section == kDatePickerSection && indexPath.row == kEndDatePickerIndex) {
        height =  self.endsDatePicker.isHidden ? 0 : kDatePickerCellHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.row != kNameCellIndex) || (indexPath.section != kTextFieldSection) || (indexPath.row != kDescriptionCellIndex)) {
        [self.nameTextField resignFirstResponder];
        [self.descriptionTextField resignFirstResponder];
    }
    
    if (indexPath.row == kStartDatePickerIndex - 1 && indexPath.section == kDatePickerSection) {
        // Hide/show Start Date picker
        self.startsDatePicker.isHidden ? [self showCellForDatePicker:self.startsDatePicker] : [self hideCellForDatePicker:self.startsDatePicker];
        [self hideCellForDatePicker:self.endsDatePicker];
    } else if (indexPath.row == kEndDatePickerIndex - 1 && indexPath.section == kDatePickerSection) {
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
        self.endsDatePicker.minimumDate = [self.startsDatePicker.date laterDate:[NSDate date]];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kErrorEmptyNameTitle
                                                            message:kErrorEmptyNameMessage
                                                           delegate:nil
                                                  cancelButtonTitle:kErrorEmptyNameCancel
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [[SKDataManager sharedManager] createEventWithName:self.nameTextField.text
                                                 startDate:self.startsDatePicker.date
                                                   endDate:self.endsDatePicker.date
                                                   details:self.descriptionTextField.text];
        [[SKDataManager sharedManager] saveContext];
        
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
    if ([textField isEqual:self.nameTextField]) {
        // Swith to description text field from name text field
        [self.nameTextField resignFirstResponder];
        [self.descriptionTextField becomeFirstResponder];
    }
    else {
        [self.descriptionTextField resignFirstResponder];
        // Show the firts date picker and hide the second one
        [self showCellForDatePicker:self.startsDatePicker];
        [self hideCellForDatePicker:self.endsDatePicker];
    }
    return YES;
}

@end
