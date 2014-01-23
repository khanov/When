//
//  SKEventsCollectionViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEventsCollectionViewController.h"
#import "SKEventCell.h"
#import "SKDetailViewController.h"
#import "SKAddEventTableViewController.h"

static NSInteger kMarginTopBottom = 30;
static NSInteger kMarginLeftRight = 10;
static NSInteger kCellWeightHeight = 145;

@interface SKEventsCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *events;
@end

@implementation SKEventsCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // whenever the collection view needs to create a cell, it uses the default UICollectionViewCell class
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EventCell"];
    
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.events count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SKEventCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    SKEvent *event = self.events[indexPath.row];
    cell.name.text = event.name;
    cell.progressView.percentInnerCircle = lroundf(event.progress * 100);
    
    NSDictionary *options = [event bestNumberAndText];
    cell.progressView.number = [[options valueForKey:@"number"] integerValue];
    cell.progressView.word = [[options valueForKey:@"text"] description];
    
    [cell.progressView setNeedsDisplay];
    
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

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
    CGSize cellSize = CGSizeMake(kCellWeightHeight, kCellWeightHeight);
    // padding
//    retval.height += 35;
//    retval.width += 35;
    return cellSize;
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
    
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
    NSLog(@"Added: %@", event);
}


@end
