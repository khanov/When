//
//  SKViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKViewController.h"
#import "SKEvent.h"

@interface SKViewController ()

@property (nonatomic, strong) SKEvent *untilDeparture;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createEvent];
    [self updateViews];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateViews)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createEvent
{
    // Time interval spent in the US
    NSString *start = @"06-08-2013 12:30:00";
    NSString *end = @"18-12-2013 19:10:00";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    self.untilDeparture = [[SKEvent alloc] initWithStartDate:[dateFormatter dateFromString:start]
                                                  andEndDate:[dateFormatter dateFromString:end]];
}

- (void)updateViews
{
    CGFloat currentProgress = [self.untilDeparture progress];
    NSLog(@"%lf", currentProgress);
    
    if (currentProgress < 0) {
        self.titleLabel.text = @"Until Departure to the US";
        self.progressBar.progress = 1.0 + currentProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (100 + currentProgress * 100)];
        
        self.secondsLabel.text = [NSString stringWithFormat:@"%.0f seconds", [self.untilDeparture.startDate timeIntervalSinceDate:[NSDate date]]];
        self.minutesLabel.text = [NSString stringWithFormat:@"or %.0f minutes", [self.untilDeparture.startDate timeIntervalSinceDate:[NSDate date]] / 60];
        self.hoursLabel.text = [NSString stringWithFormat:@"or %.0f hours", [self.untilDeparture.startDate timeIntervalSinceDate:[NSDate date]] / 3600];
        self.daysLabel.text = [NSString stringWithFormat:@"or %.0f days", [self.untilDeparture.startDate timeIntervalSinceDate:[NSDate date]] / 3600 / 24];
    }
    else {
        self.titleLabel.text = @"My Global UGRAD Progress";
        self.subTitleLabel.text = @"Until Departure:";
        self.progressBar.progress = currentProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (currentProgress * 100)];
        
        self.secondsLabel.text = [NSString stringWithFormat:@"%.0f seconds", [self.untilDeparture.endDate timeIntervalSinceDate:[NSDate date]]];
        self.minutesLabel.text = [NSString stringWithFormat:@"or %.0f minutes", [self.untilDeparture.endDate timeIntervalSinceDate:[NSDate date]] / 60];
        self.hoursLabel.text = [NSString stringWithFormat:@"or %.0f hours", [self.untilDeparture.endDate timeIntervalSinceDate:[NSDate date]] / 3600];
        self.daysLabel.text = [NSString stringWithFormat:@"or %.0f days", [self.untilDeparture.endDate timeIntervalSinceDate:[NSDate date]] / 3600 / 24];
    }
}

@end
