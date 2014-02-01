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
#import "SKCustomCollectionViewFlowLayout.h"
#import "SKAppDelegate.h"

static NSInteger kMarginTopBottom = 12;
static NSInteger kMarginLeftRight = 10;
static NSInteger kCellWeightHeight = 145;

@interface SKEventsCollectionViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSMutableArray *fetchedEventsArray;

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
    [self setupColors];
    [self registerForNotifications];

    // Allocate and configure the layout.
    SKCustomCollectionViewFlowLayout *layout = [[SKCustomCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    self.collectionView.collectionViewLayout = layout;
    // Set navigation bar font
    UIFont *backButtonFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : backButtonFont} forState:UIControlStateNormal];
    // Long press gesture recognizer
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    gestureRecognizer.minimumPressDuration = 0.5; //seconds
    gestureRecognizer.delegate = self;
    gestureRecognizer.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:gestureRecognizer];
}

- (void)setupColors
{
    SKAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSDictionary *colors = [delegate currentTheme];
    self.collectionView.backgroundColor = [colors objectForKey:@"background"];
    self.navigationController.navigationBar.backgroundColor = [colors objectForKey:@"background"];
    self.navigationController.navigationBar.tintColor = [colors objectForKey:@"tint"];

}

#pragma mark Model Notifications

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventAdded:)
                                                 name:@"EventAdded"
                                               object:nil];
}

- (void)eventAdded:(NSNotification *)addedNotification
{
    if ([[addedNotification.userInfo allKeys][0] isEqual:@"added"]) {
        SKEvent *eventToAdd = [addedNotification.userInfo objectForKey:@"added"];
        self.fetchedEventsArray = [NSMutableArray arrayWithArray:[[SKDataManager sharedManager] getAllEvents]];
        NSInteger index = [self.fetchedEventsArray indexOfObject:eventToAdd];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }
}

#pragma mark Update View

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchedEventsArray = [NSMutableArray arrayWithArray:[[SKDataManager sharedManager] getAllEvents]];
    [self updateView];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)startTimer
{
    if ([self.fetchedEventsArray count] && self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateView
{
    NSLog(@"----------- update view");
    self.fetchedEventsArray = [NSMutableArray arrayWithArray:[[SKDataManager sharedManager] getAllEvents]];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isEditing == NO) {
        [self startTimer];
    }
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
    cell.progressView.percentCircle = [event progress] * 100;
    
    self.isEditing ? [cell startQuivering] : [cell stopQuivering];
    
    NSDictionary *options = [event bestNumberAndText];
    cell.progressView.progressLabel.text = [options valueForKey:@"number"];
    cell.progressView.metaLabel.text = [options valueForKey:@"text"];
    
    // for events that haven't yet started, use smaller text
    if ([event progress] < 0) {
        [cell.progressView useSmallerFont];
    }
    else {
        [cell.progressView useDefaultFont];
    }
    
    [cell.progressView setNeedsDisplay];
    
    return cell;
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
    if ([segue.identifier isEqualToString:@"showEventDetailsView"]) {
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

- (void)longPressGesture:(UIGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        // Replace Add button to Done
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
        [self.navigationItem setRightBarButtonItem:done];
        // Start Editing mode
        NSLog(@"Start editing");
        self.editing = YES;
        [self stopTimer];
        [self updateView];
    }
}

- (IBAction)deleteButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(SKEventCell *)sender.superview.superview];
    [[SKDataManager sharedManager] deleteEvent:self.fetchedEventsArray[indexPath.row]];
    [[SKDataManager sharedManager] saveContext];
    self.fetchedEventsArray = [NSMutableArray arrayWithArray:[[SKDataManager sharedManager] getAllEvents]];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)doneEditing
{
    NSLog(@"Done editing");
    // Replace Add button to Done
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add-icon"]
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(showAddEventView)];
    [self.navigationItem setRightBarButtonItem:add];
    // Stop Edit mode
    self.editing = NO;
    [self startTimer];
    [self updateView];
}

@end
