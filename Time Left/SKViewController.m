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

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createEvent];
    [self updateViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createEvent
{
    // Time interval spent in the US
    NSString *start = @"06-08-2013";
    NSString *end = @"18-12-2013";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    self.untilDeparture = [[SKEvent alloc] initWithStartDate:[dateFormatter dateFromString:start]
                                                  andEndDate:[dateFormatter dateFromString:end]];
}

- (void)updateViews
{
    CGFloat currentProgress = [self.untilDeparture progress];
    NSLog(@"%lf", currentProgress);
    
    if (currentProgress < 0) {
        self.titleLabel.text = @"Until Departure to the US";
        self.progressBar.progress = -currentProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (-currentProgress * 100)];
    }
    else {
        self.titleLabel.text = @"Global UGRAD Progress";
        self.progressBar.progress = currentProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (currentProgress * 100)];
    }
}

@end
