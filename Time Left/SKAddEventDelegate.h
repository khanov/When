//
//  SKAddEventDelegate.h
//  Time Left
//
//  Created by Salavat Khanov on 1/20/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEvent.h"

@protocol SKAddEventDelegate <NSObject>

- (void)saveEventDetails:(SKEvent *)event;

@end
