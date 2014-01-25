//
//  SKEventsCollectionViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEventsCollectionViewController.h"
#import "SKEventCell.h"
#import "SKEventDetailsViewController.h"
#import "SKAddEventTableViewController.h"

static NSInteger kMarginTopBottom = 0;
static NSInteger kMarginLeftRight = 10;
static NSInteger kCellWeightHeight = 145;

@interface SKEventsCollectionViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSArray *fetchedEventsArray;
@end

@implementation SKEventsCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    // Time interval spent in the US
    NSString *start1 = @"06-08-2013 12:30:00";
    NSString *end1 = @"17-12-2013 19:10:00";
    
    NSString *start2 = @"23-12-2013 00:00:00";
    NSString *end2 = @"23-12-2015 00:00:00";
    
    NSString *start3 = @"22-01-2014 21:00:00";
    NSString *end3 = @"24-01-2014 00:00:00";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    self.events = [[NSMutableArray alloc] init];
    [self.events addObject:[[SKEvent alloc] initWithName:@"Global UGRAD" startDate:[dateFormatter dateFromString:start1]
                                                 endDate:[dateFormatter dateFromString:end1] andDetails:@"United States of America"]];
    
    [self.events addObject:[[SKEvent alloc] initWithName:@"Home Residence" startDate:[dateFormatter dateFromString:start2]
                                                 endDate:[dateFormatter dateFromString:end2] andDetails:@"2 Year Home Residence Rule"]];
    
    [self.events addObject:[[SKEvent alloc] initWithName:@"Weekend" startDate:[dateFormatter dateFromString:start3]
                                                 endDate:[dateFormatter dateFromString:end3] andDetails:@"Until the Weekend"]];
    
    */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
    // setup timer to update view every second
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // stop timer
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateView
{
    self.fetchedEventsArray = [[SKDataManager sharedManager] getAllEvents];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedEventsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SKEventCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    SKEvent *event = self.fetchedEventsArray[indexPath.row];
    cell.name.text = event.name;
    cell.progressView.percentInnerCircle = lroundf(event.progress * 100);
    
    NSDictionary *options = [event bestNumberAndText];
    cell.progressView.number = [[options valueForKey:@"number"] integerValue];
    cell.progressView.word = [[options valueForKey:@"text"] description];
    
    [cell.progressView setNeedsDisplay];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWeightHeight, kCellWeightHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMarginTopBottom, kMarginLeftRight, kMarginTopBottom, kMarginLeftRight);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showEventView"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        SKEventDetailsViewController *eventDetailsViewController = segue.destinationViewController;
        eventDetailsViewController.event = [self.fetchedEventsArray objectAtIndex:indexPath.row];
    }
}

@end
