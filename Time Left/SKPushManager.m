//
//  SKPushManager.m
//  Time Left
//
//  Created by Salavat Khanov on 1/31/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKPushManager.h"
#import "SKDataManager.h"

@interface SKPushManager ()
@property (strong, nonatomic) NSMutableArray *notifications;
@end

@implementation SKPushManager

// Lazy init
- (NSMutableArray *)notifications
{
    if (_notifications == nil) {
        _notifications = [[NSMutableArray alloc] init];
    }
    
    return _notifications;
}

#pragma mark Model Notifications

- (void)registerForModelUpdateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventAdded:)
                                                 name:kEventAddedNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventUpdated:)
                                                 name:kEventDeletedNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventDeleted:)
                                                 name:kEventUpdatedNotificationName
                                               object:nil];
}

- (void)eventAdded:(NSNotification *)addedNotification
{
    if ([[addedNotification.userInfo allKeys][0] isEqual:kAddedKey]) {
        
        SKEvent *eventToAdd = [addedNotification.userInfo objectForKey:kAddedKey];
        UILocalNotification *localNotification = [self createNotificationForEvent:eventToAdd];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self.notifications addObject:localNotification];

        NSLog(@"Scheduled notification for %@ at %@ (now = %@)", eventToAdd.name, localNotification.fireDate, [NSDate date]);
    }
}

- (void)eventUpdated:(NSNotification *)updatedNotification
{
    if ([[updatedNotification.userInfo allKeys][0] isEqual:kUpdatedKey]) {
        SKEvent *updatedEvent = [updatedNotification.userInfo objectForKey:kUpdatedKey];
        // Find notification to cancel
        [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger eventHash = [[((UILocalNotification *)obj).userInfo objectForKey:@"eventHash"] integerValue];
            if (eventHash == [updatedEvent hash]) {
                [[UIApplication sharedApplication] cancelLocalNotification:(UILocalNotification *)obj];
                [self.notifications removeObject:obj];
                
                UILocalNotification *newNotification = [self createNotificationForEvent:updatedEvent];
                [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                [self.notifications addObject:newNotification];
                *stop = YES;
                
                NSLog(@"Updated notification for %@ at %@ (now = %@)", updatedEvent.name, ((UILocalNotification *)obj).fireDate, [NSDate date]);
            }
        }];
    }
}

- (void)eventDeleted:(NSNotification *)deletedNotification
{
    if ([[deletedNotification.userInfo allKeys][0] isEqual:kDeletedKey]) {
        SKEvent *eventToDelete = [deletedNotification.userInfo objectForKey:kDeletedKey];
        // Find notification to cancel
        [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger eventHash = [[((UILocalNotification *)obj).userInfo objectForKey:@"eventHash"] integerValue];
            if (eventHash == [eventToDelete hash]) {
                [[UIApplication sharedApplication] cancelLocalNotification:(UILocalNotification *)obj];
                [self.notifications removeObject:obj];
                *stop = YES;
                
                NSLog(@"Cancelled notification for %@ at %@ (now = %@)", eventToDelete.name, ((UILocalNotification *)obj).fireDate, [NSDate date]);
            }
        }];
    }
}

- (UILocalNotification *)createNotificationForEvent:(SKEvent *)event
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = event.endDate;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ is happening now.", event.name];
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.alertAction = NSLocalizedString(@"check", @"On lock screen under notification — 'slide to ...' ");
    localNotification.soundName = @"notification-sound.caf";
    localNotification.userInfo = @{@"eventHash" : @([event hash])};
    return localNotification;
}

@end
