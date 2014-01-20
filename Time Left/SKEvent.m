//
//  SKEvent.m
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKEvent.h"

@implementation SKEvent

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    self = [super init];
    if (self) {
        _name = name;
        _startDate = startDate;
        _endDate = endDate;
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

- (id)init
{
    return [self initWithName:nil startDate:nil andEndDate:nil];
}

@end
