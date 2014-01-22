//
//  SKEvent.m
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKEvent.h"

static NSString *kDays = @"DAYS LEFT";
static NSString *kHours = @"HOURS LEFT";
static NSString *kMinutes = @"MINS LEFT";
static NSString *kSeconds = @"SECS LEFT";

@implementation SKEvent

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate andDetails:(NSString *)description;
{
    self = [super init];
    if (self) {
        _name = name;
        _startDate = startDate;
        _endDate = endDate;
        _details = description;
    }
    
    return self;
}

- (CGFloat)progress
{
    if (self.startDate && self.endDate) {
        NSTimeInterval intervalSinceStart = [self.endDate timeIntervalSinceDate:self.startDate];
        NSTimeInterval intervalSinceNow = [[NSDate date] timeIntervalSinceDate:self.startDate];
        return intervalSinceNow / intervalSinceStart;
    }
    
    NSLog(@"Error: start date or end date is invalid");
    return 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name '%@', startDate '%@', endDate '%@', desc '%@'", self.name, self.startDate, self.endDate, self.details];
}

- (NSInteger)daysLeft
{
    return lroundf([self hoursLeft] / 24.0);
}

- (NSInteger)hoursLeft
{
    return lroundf([self minutesLeft] / 60.0);
}

- (NSInteger)minutesLeft
{
    return lroundf([self secondsLeft] / 60.0);
}

- (NSInteger)secondsLeft
{
    return lroundf([self.endDate timeIntervalSinceDate:[NSDate date]]);
}

- (NSDictionary *)bestNumberAndText
{
    NSNumber *number;
    NSString *text;
    
    if ([self daysLeft] > 2) {
        NSLog(@"days left: %lf", [self hoursLeft] / 24.0);
        number = @([self daysLeft]);
        text = kDays;
    }
    else if ([self hoursLeft] > 2) {
        number = @([self hoursLeft]);
        text = kHours;
    }
    else if ([self minutesLeft] > 2) {
        number = @([self minutesLeft]);
        text = kMinutes;
    }
    else {
        number = @([self secondsLeft]);
        text = kSeconds;
    }
    
    return @{@"number": number,
             @"text" : text};
}

@end
