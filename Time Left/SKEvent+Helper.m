//
//  SKEvent+Helper.m
//  Time Left
//
//  Created by Salavat Khanov on 1/25/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEvent+Helper.h"

static NSString *kDays = @"DAYS LEFT";
static NSString *kHours = @"HRS LEFT";
static NSString *kMinutes = @"MINS LEFT";
static NSString *kSeconds = @"SECS LEFT";
static NSString *kDone = @"DONE";

@implementation SKEvent (Helper)

- (CGFloat)progress
{
    if (self.startDate && self.endDate) {
        NSTimeInterval intervalSinceStart = [self.endDate timeIntervalSinceDate:self.startDate];
        NSTimeInterval intervalSinceNow = [[NSDate date] timeIntervalSinceDate:self.startDate];
        
        NSLog(@"progress: %f", intervalSinceNow / intervalSinceStart);
        return intervalSinceNow / intervalSinceStart;
    }
    
    NSLog(@"Error: start date or end date is invalid");
    return 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name '%@', startDate '%@', endDate '%@', desc '%@'", self.name, self.startDate, self.endDate, self.details];
}

- (NSInteger)daysLeftToDate:(NSDate *)date
{
    return lroundf([self hoursLeftToDate:date] / 24.0);
}

- (NSInteger)hoursLeftToDate:(NSDate *)date
{
    return lroundf([self minutesLeftToDate:date] / 60.0);
}

- (NSInteger)minutesLeftToDate:(NSDate *)date
{
    return lroundf([self secondsLeftToDate:date] / 60.0);
}

- (NSInteger)secondsLeftToDate:(NSDate *)date
{
    return lroundf([date timeIntervalSinceDate:[NSDate date]]);
}

- (NSDictionary *)bestNumberAndText
{
    NSNumber *number;
    NSString *text;
    
    if ([self.startDate compare:[NSDate date]] == NSOrderedDescending) {
        // Start date is in the future
        NSLog(@"start date is in the future");
        if ([self daysLeftToDate:self.startDate] > 2) {
            number = @([self daysLeftToDate:self.startDate]);
            text = kDays;
        }
        else if ([self hoursLeftToDate:self.startDate] > 2) {
            number = @([self hoursLeftToDate:self.startDate]);
            text = kHours;
        }
        else if ([self minutesLeftToDate:self.startDate] > 5) {
            number = @([self minutesLeftToDate:self.startDate]);
            text = kMinutes;
        }
        else if ([self secondsLeftToDate:self.startDate] >= 0) {
            number = @([self secondsLeftToDate:self.startDate]);
            text = kSeconds;
        }
        else {
            number = @(0);
            text = kDone;
        }
    } else {
        // Start date is in the past
        if ([self daysLeftToDate:self.endDate] > 2) {
            number = @([self daysLeftToDate:self.endDate]);
            text = kDays;
        }
        else if ([self hoursLeftToDate:self.endDate] > 2) {
            number = @([self hoursLeftToDate:self.endDate]);
            text = kHours;
        }
        else if ([self minutesLeftToDate:self.endDate] > 5) {
            number = @([self minutesLeftToDate:self.endDate]);
            text = kMinutes;
        }
        else if ([self secondsLeftToDate:self.endDate] >= 0) {
            number = @([self secondsLeftToDate:self.endDate]);
            text = kSeconds;
        }
        else {
            number = @(0);
            text = kDone;
        }
    }
    
    return @{@"number": number,
             @"text" : text};
}

@end
