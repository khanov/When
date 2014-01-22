//
//  SKEvent.h
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKEvent : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate andDetails:(NSString *)details;
- (CGFloat)progress;
- (NSString *)description;

- (NSInteger)daysLeft;
- (NSInteger)hoursLeft;
- (NSInteger)minutesLeft;
- (NSInteger)secondsLeft;

- (NSDictionary *)bestNumberAndText;

@end
