//
//  SKDataManager.m
//  Time Left
//
//  Created by Salavat Khanov on 1/25/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKDataManager.h"

static NSString *kModelName = @"AppModel";
static NSString *kSQLName = @"TimeLeft.sqlite";
static NSString *kEventEntityName = @"Event";


@interface SKDataManager ()
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation SKDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (SKDataManager*)sharedManager
{
	static dispatch_once_t once;
	static SKDataManager *sharedManager;
    
    dispatch_once(&once, ^{
        sharedManager = [[SKDataManager alloc] init];
    });
    
    return sharedManager;
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *psc = [self persistentStoreCoordinator];
    
    if (psc) {
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: psc];
        }];
        
        NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
        [dc addObserver:self
               selector:@selector(objectContextDidSave:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:_managedObjectContext];
        
        _managedObjectContext = moc;
    } else {
        NSLog(@"Error while creating coordinator");
    }
    
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(storesWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:_persistentStoreCoordinator];
    
    [dc addObserver:self
           selector:@selector(storesDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:_persistentStoreCoordinator];
    
    [dc addObserver:self
           selector:@selector(persistentStoreDidImportUbiquitiousContentChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:_persistentStoreCoordinator];
    
    [self addPersistentStoreToCoordinator];
	
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Adding persistent stores

- (void)addPersistentStoreToCoordinator
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:@YES forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:@YES forKey:NSInferMappingModelAutomaticallyOption];
    
    NSURL *iCloud = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier: nil];
    
    if (iCloud) {
        [options setObject:@"6P9PN587KS~com~khanov~When" forKey:NSPersistentStoreUbiquitousContentNameKey];
    }
    
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    
    NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:kSQLName];
    
    NSError *error;
    
    // the only difference in this call that makes the store an iCloud enabled store
    // is the NSPersistentStoreUbiquitousContentNameKey in options.
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeURL
                                                    options:options
                                                      error:&error];
    if (error) {
        NSLog(@"Error adding persistent store coordinator: %@", [error localizedDescription]);
    }
}


#pragma mark -
#pragma mark Save Context

- (void)saveTheContext:(NSManagedObjectContext *)theContext
{
    if ([self.persistentStoreCoordinator.persistentStores count] != 0) {

        NSError *error = nil;
        [theContext save:&error];
        if (error) {
            NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if (detailedErrors != nil && [detailedErrors count] > 0) {
                for (NSError *detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
    }
}

- (void)saveContext
{
    [self saveTheContext:self.managedObjectContext];
}

#pragma mark -
#pragma mark Events

- (NSArray *)getAllEvents
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEventEntityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedEvents = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Sort events in descending order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil
                                                                ascending:YES
                                                               comparator:^NSComparisonResult(SKEvent *obj1, SKEvent *obj2) {
                                                                   return [obj1.createdDate compare:obj2.createdDate];
                                                               }];
    
    // Return Sorted Fetched Events
    return [fetchedEvents sortedArrayUsingDescriptors:@[sortDescriptor]];;
}

- (SKEvent *)createEventWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate details:(NSString *)details
{
    SKEvent *newEvent = (SKEvent *)[NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:self.managedObjectContext];
    newEvent.name = name;
    newEvent.details = details;
    newEvent.startDate = startDate;
    newEvent.endDate = endDate;
    newEvent.createdDate = [NSDate date];
    return newEvent;
}

- (void)deleteEvent:(SKEvent *)event
{
    [self.managedObjectContext deleteObject:event];
}

- (void)createDefaultEvents
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //
    // New Year
    [comps setYear:[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year] + 1]; // current year + 1 = next year
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *nextYear = [gregorianCalendar dateFromComponents:comps];
    // Current year
    [comps setYear:[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year]]; // current year
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *firstDayOfTheYear = [gregorianCalendar dateFromComponents:comps];

    firstDayOfTheYear = [NSDate dateWithTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT] sinceDate:firstDayOfTheYear]; // time zone offset
    
    [self createEventWithName:@"New Year"
                    startDate:firstDayOfTheYear
                      endDate:nextYear
                      details:[NSString stringWithFormat:@"Time Left Until 1st Jan, %d", [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:nextYear] year]]];
    
    
    //
    // Next Sunday
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [gregorianCalendar components:NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:now];
    NSInteger weekday = [dateComponents weekday];
    
    NSDate *nextSunday = nil;
    if (weekday == 1 && [dateComponents hour] < 12) {
        // Sunday is today. Find next.
        NSInteger daysTillNextSunday = 8;
        int secondsInDay = 86400; // 24 * 60 * 60
        nextSunday = [now dateByAddingTimeInterval:secondsInDay * daysTillNextSunday];
    }
    else {
        NSInteger daysTillNextSunday = 8 - weekday;
        int secondsInDay = 86400; // 24 * 60 * 60
        nextSunday = [now dateByAddingTimeInterval:secondsInDay * daysTillNextSunday];
    }
        
    [self createEventWithName:@"Fun With Friends"
                    startDate:now
                      endDate:nextSunday
                      details:@"Next Sunday is going to be fun!"];
    
    
    //
    // Installed the app
    [self createEventWithName:@"Install This App"
                    startDate:firstDayOfTheYear
                      endDate:[NSDate date]
                      details:@""];
    
    [self saveContext];
    
}

- (void)deleteAllEvents
{
    NSFetchRequest *allEvents = [[NSFetchRequest alloc] init];
    [allEvents setEntity:[NSEntityDescription entityForName:kEventEntityName inManagedObjectContext:self.managedObjectContext]];
    [allEvents setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *events = [self.managedObjectContext executeFetchRequest:allEvents error:&error];

    for (NSManagedObject * event in events) {
        [self.managedObjectContext deleteObject:event];
    }
}

#pragma mark -
#pragma mark iCloud notifications

- (void)persistentStoreDidImportUbiquitiousContentChanges:(NSNotification *)changeNotification
{
    NSLog(@"Merging changes from iCloud");
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:changeNotification];
        [self objectContextDidSaveFromiCloud:changeNotification];
    }];
}

- (void)storesWillChange:(NSNotification *)n
{
    NSManagedObjectContext *moc = [self managedObjectContext];
    [moc performBlockAndWait:^{
        NSError *error = nil;
        if ([moc hasChanges]) {
            [moc save:&error];
        }
        
        [moc reset];
    }];
    
    NSLog(@"storesWillChange");
}


- (void)storesDidChange:(NSNotification *)n
{
    NSLog(@"storesDidChange");
}


#pragma mark -
#pragma mark Model notifications

static NSString *kEventAddedNotificationName = @"EventAdded";
static NSString *kEventDeletedNotificationName = @"EventDeleted";

static NSString *kAddedKey = @"added";
static NSString *kDeletedKey = @"deleted";

- (void)objectContextDidSave:(NSNotification *)notification
{
    // Event inserted
    if ([notification.userInfo objectForKey:NSInsertedObjectsKey]) {
        for (id object in [notification.userInfo objectForKey:NSInsertedObjectsKey]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kEventAddedNotificationName
                                                                object:self
                                                              userInfo:@{kAddedKey: object}];
        }
    }
    // Event deleted
    if ([notification.userInfo objectForKey:NSDeletedObjectsKey]) {
        for (id object in [notification.userInfo objectForKey:NSDeletedObjectsKey]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kEventDeletedNotificationName
                                                                object:self
                                                              userInfo:@{kDeletedKey: object}];
        }
    }
    
}

- (void)objectContextDidSaveFromiCloud:(NSNotification *)notification
{
    // Event inserted
    NSDictionary *insertedObjectIDs = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
    if (insertedObjectIDs) {
        for (NSManagedObjectID *objID in insertedObjectIDs) {
            NSError *error = nil;
            NSManagedObject *object = [self.managedObjectContext existingObjectWithID:objID error:&error];
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kEventAddedNotificationName
                                                                    object:self
                                                                  userInfo:@{kAddedKey: object}];
            }
        }
    }
    
    // Event deleted
    NSDictionary *deletedObjectIDs = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
    
    if (deletedObjectIDs) {
        for (NSManagedObjectID *objID in deletedObjectIDs) {
            NSError *error = nil;
            NSManagedObject *object = [self.managedObjectContext existingObjectWithID:objID error:&error];
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kEventDeletedNotificationName
                                                                    object:self
                                                                  userInfo:@{kDeletedKey: object}];
            }
        }
    }
}

@end
