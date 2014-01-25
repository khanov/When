//
//  SKEvent+Helper.h
//  Time Left
//
//  Created by Salavat Khanov on 1/25/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEvent.h"

@protocol SKEventMethods <NSObject>

@required
- (CGFloat)progress;
- (NSInteger)daysLeft;
- (NSInteger)hoursLeft;
- (NSInteger)minutesLeft;
- (NSInteger)secondsLeft;
- (NSDictionary *)bestNumberAndText;

@end


@interface SKEvent (Helper) <SKEventMethods>

- (CGFloat)progress;
- (NSString *)description;

- (NSInteger)daysLeft;
- (NSInteger)hoursLeft;
- (NSInteger)minutesLeft;
- (NSInteger)secondsLeft;

- (NSDictionary *)bestNumberAndText;

@end
