//
//  SKEventDetailsViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 1/20/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEventDetailsViewController.h"

@interface SKEventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet SKProgressIndicator *progressView;
@property (strong, nonatomic) NSTimer *timer;

- (IBAction)swipeGesture:(id)sender;

@end

@implementation SKEventDetailsViewController

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
    [self setupLabels];
    [self setupColors];
    [self updateProgressView];
}

- (void)setupColors
{
    UIColor *dayColor = [UIColor colorWithRed:255/255.0 green:149/255.0 blue:0/255.0 alpha:1.0];
//    UIColor *nightColor = [UIColor colorWithRed:36/255.0 green:15/255.0 blue:46/255.0 alpha:1.0];
    
    self.view.backgroundColor = dayColor;
//    self.view.backgroundColor = nightColor;
    
    self.navigationController.navigationBar.backgroundColor = dayColor;
//    self.navigationController.navigationBar.backgroundColor = nightColor;
}

- (void)setupLabels
{
    self.nameLabel.text = self.event.name;
    if (self.event.details.length == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.descriptionLabel.text = [dateFormatter stringFromDate:self.event.endDate];
    } else {
        self.descriptionLabel.text = self.event.details;
    }
}

- (void)updateProgressView
{
    // Set percent for progress indicator
    NSInteger currentProgressPercent = lroundf([self.event progress] * 100);
    self.progressView.percentInnerCircle = currentProgressPercent;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"ss"];
    NSInteger secs = [[DateFormatter stringFromDate:[NSDate date]] integerValue];
    self.progressView.percentOuterCircle = secs * 100 / 60.0;
    
    // Set the best number and word to display
    NSDictionary *options = [self.event bestNumberAndText];
    self.progressView.number = [[options valueForKey:@"number"] integerValue];
    self.progressView.word = [[options valueForKey:@"text"] description];
    
    // Redraw
    [self.progressView setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)swipeGesture:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
