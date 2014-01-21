//
//  SKDetailViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKDetailViewController.h"

@interface SKDetailViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SKDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViews];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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


- (void)updateViews
{
//    CGFloat currentProgress = [self.event progress];
//    NSLog(@"%lf", currentProgress);
//    
//    if (currentProgress < 0) {
//        self.titleLabel.text = self.event.name;
//        self.progressBar.progress = 1.0 + currentProgress;
//        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (100 + currentProgress * 100)];
//        
//        self.secondsLabel.text = [NSString stringWithFormat:@"%.0f seconds", [self.event.startDate timeIntervalSinceDate:[NSDate date]]];
//        self.minutesLabel.text = [NSString stringWithFormat:@"or %.0f minutes", [self.event.startDate timeIntervalSinceDate:[NSDate date]] / 60];
//        self.hoursLabel.text = [NSString stringWithFormat:@"or %.0f hours", [self.event.startDate timeIntervalSinceDate:[NSDate date]] / 3600];
//        self.daysLabel.text = [NSString stringWithFormat:@"or %.0f days", [self.event.startDate timeIntervalSinceDate:[NSDate date]] / 3600 / 24];
//    }
//    else {
//        self.titleLabel.text = self.event.name;
//        self.subTitleLabel.text = @"Time Left:";
//        self.progressBar.progress = currentProgress;
//        self.progressLabel.text = [NSString stringWithFormat:@"%.0lf%%", (currentProgress * 100)];
//        
//        self.secondsLabel.text = [NSString stringWithFormat:@"%.0f seconds", [self.event.endDate timeIntervalSinceDate:[NSDate date]]];
//        self.minutesLabel.text = [NSString stringWithFormat:@"or %.0f minutes", [self.event.endDate timeIntervalSinceDate:[NSDate date]] / 60];
//        self.hoursLabel.text = [NSString stringWithFormat:@"or %.0f hours", [self.event.endDate timeIntervalSinceDate:[NSDate date]] / 3600];
//        self.daysLabel.text = [NSString stringWithFormat:@"or %.0f days", [self.event.endDate timeIntervalSinceDate:[NSDate date]] / 3600 / 24];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
