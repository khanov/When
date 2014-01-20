//
//  SKTableViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 12/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKEventsTableViewController.h"
#import "SKDetailViewController.h"
#import "SKAddEventTableViewController.h"

@interface SKEventsTableViewController ()

@property (strong, nonatomic) NSMutableArray *events;

@end

@implementation SKEventsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addItemToTableView)];
    
    // Time interval spent in the US
    NSString *start1 = @"06-08-2013 12:30:00";
    NSString *end1 = @"17-12-2013 19:10:00";
    
    NSString *start2 = @"23-12-2013 00:00:00";
    NSString *end2 = @"23-12-2015 00:00:00";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    self.events = [[NSMutableArray alloc] init];
    [self.events addObject:[[SKEvent alloc] initWithName:@"Global UGRAD" startDate:[dateFormatter dateFromString:start1]
                                                   andEndDate:[dateFormatter dateFromString:end1]]];
    
    [self.events addObject:[[SKEvent alloc] initWithName:@"Home Residence" startDate:[dateFormatter dateFromString:start2]
                                                   andEndDate:[dateFormatter dateFromString:end2]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    SKEvent *event = [self.events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.name;
    return cell;
}


#pragma mark - Editing

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.events removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    SKEvent *tmp = [self.events objectAtIndex:toIndexPath.row];
    [self.events replaceObjectAtIndex:toIndexPath.row withObject:[self.events objectAtIndex:fromIndexPath.row]];
    [self.events replaceObjectAtIndex:fromIndexPath.row withObject:tmp];
}

// Adding to the table view.
- (void)addItemToTableView
{
    [self performSegueWithIdentifier:@"showAddEventView" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showEventDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SKDetailViewController *eventDetailsViewController = segue.destinationViewController;
        eventDetailsViewController.event = [self.events objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"showAddEventView"]) {
        SKAddEventTableViewController *controller = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        controller.delegate = self;
    }
}

- (void)saveEventDetails:(SKEvent *)event
{
    [self.events addObject:event];
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:[self.events count]-1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"Added: %@", event);
}

@end
