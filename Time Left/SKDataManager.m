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
        [options setObject:@"6P9PN587KS~com~khanov~Time-Left" forKey:NSPersistentStoreUbiquitousContentNameKey];
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
    
    // Returning Fetched Events
    return fetchedEvents;
}

- (SKEvent *)createEventWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate details:(NSString *)details
{
    SKEvent *newEvent = (SKEvent *)[NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:self.managedObjectContext];
    newEvent.name = name;
    newEvent.details = details;
    newEvent.startDate = startDate;
    newEvent.endDate = endDate;
    return newEvent;
}

- (void)deleteEvent:(SKEvent *)event
{
    NSLog(@"Deleted: %@", event);
    [self.managedObjectContext deleteObject:event];
}

- (void)createDefaultEvents
{
    NSString *start1 = @"06-08-2013 12:30:00";
    NSString *end1 = @"17-12-2013 19:10:00";
    
    NSString *start2 = @"23-12-2013 00:00:00";
    NSString *end2 = @"23-12-2015 00:00:00";
    
    NSString *start3 = @"22-01-2014 21:00:00";
    NSString *end3 = @"24-01-2014 00:00:00";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    [self createEventWithName:@"Global UGRAD"
                    startDate:[dateFormatter dateFromString:start1]
                      endDate:[dateFormatter dateFromString:end1]
                      details:@"United States of America"];
    
    [self createEventWithName:@"Home Residence"
                    startDate:[dateFormatter dateFromString:start2]
                      endDate:[dateFormatter dateFromString:end2]
                      details:@"2 Year Home Residence Rule"];
    
    [self createEventWithName:@"Weekend"
                    startDate:[dateFormatter dateFromString:start3]
                      endDate:[dateFormatter dateFromString:end3]
                      details:@"Until the Weekend"];
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

- (void)swapEvent:(SKEvent *)thisEvent withOtherEvent:(SKEvent *)otherEvent
{
    id tmp;
    
    tmp = thisEvent.name;
    thisEvent.name = otherEvent.name;
    otherEvent.name = tmp;
    
    tmp = thisEvent.details;
    thisEvent.details = otherEvent.details;
    otherEvent.details = tmp;
    
    tmp = thisEvent.startDate;
    thisEvent.startDate = otherEvent.startDate;
    otherEvent.startDate = tmp;
    
    tmp = thisEvent.endDate;
    thisEvent.endDate = otherEvent.endDate;
    otherEvent.endDate = tmp;
    
}


#pragma mark -
#pragma mark iCloud notifications

- (void)persistentStoreDidImportUbiquitiousContentChanges:(NSNotification*)changeNotification
{
    NSLog(@"Merging changes from iCloud");
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:changeNotification];
        [self eventAddedNotification];
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


- (void)eventAddedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventUpdated"
                                                         object:self
                                                       userInfo:nil];
}

@end
