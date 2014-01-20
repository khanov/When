//
//  SKTableViewController.h
//  Time Left
//
//  Created by Salavat Khanov on 12/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEvent.h"
#import "SKAddEventDelegate.h"

@interface SKEventsTableViewController : UITableViewController <SKAddEventDelegate>

- (void)saveEventDetails:(SKEvent *)event;


@end
