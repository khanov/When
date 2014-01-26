//
//  SKDataManager.h
//  Time Left
//
//  Created by Salavat Khanov on 1/25/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEvent.h"
#import "SKEvent+Helper.h"

@interface SKDataManager : NSObject

+ (SKDataManager *)sharedManager;
- (void)saveContext;

// Bulk Add/Delete
- (void)createDefaultEvents;
- (void)deleteAllEvents;

// Events
- (NSArray *)getAllEvents;
- (SKEvent *)createEventWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate details:(NSString *)details;
- (void)swapEvent:(SKEvent *)thisEvent withOtherEvent:(SKEvent *)otherEvent;
- (void)deleteEvent:(SKEvent *)event;

@end
