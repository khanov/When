//
//  SKEventsCollectionViewController.h
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEvent.h"
#import "SKAddEventDelegate.h"

@interface SKEventsCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKAddEventDelegate>

- (void)saveEventDetails:(SKEvent *)event;

@end
