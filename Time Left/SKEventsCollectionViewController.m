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

- (IBAction)longPressGesture:(UIGestureRecognizer *)recognizer;
- (IBAction)deleteButton:(UIButton *)sender;

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
    
//    [[SKDataManager sharedManager] createDefaultEvents];
//    [[SKDataManager sharedManager] deleteAllEvents];
    
//    [[SKDataManager sharedManager] saveContext];

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
    
    self.isEditing ? [cell startQuivering] : [cell stopQuivering];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showEventView"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        SKEventDetailsViewController *eventDetailsViewController = segue.destinationViewController;
        eventDetailsViewController.event = [self.fetchedEventsArray objectAtIndex:indexPath.row];
    }
}

- (void)showAddEventView
{
    [self performSegueWithIdentifier:@"showAddEventView" sender:nil];
}

#pragma mark - Edit mode

- (IBAction)longPressGesture:(UIGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        // Replace Add button to Done
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
        [self.navigationItem setRightBarButtonItem:done];
        // Start Editing mode
        NSLog(@"Start editing");
        self.editing = YES;
        [self updateView];
    }
}

- (IBAction)deleteButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(SKEventCell *)sender.superview.superview];
    [[SKDataManager sharedManager] deleteEvent:self.fetchedEventsArray[indexPath.row]];
    [[SKDataManager sharedManager] saveContext];
}

- (void)doneEditing
{
    NSLog(@"Done editing");
    // Replace Add button to Done
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddEventView)];
    [self.navigationItem setRightBarButtonItem:add];
    // Stop Edit mode
    self.editing = NO;
    [self updateView];
}

@end
