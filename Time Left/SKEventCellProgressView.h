//
//  SKEventCellProgressView.h
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKEventCellProgressView : UIView

@property (assign, nonatomic) NSInteger percentInnerCircle;
@property (assign, nonatomic) CGFloat percentOuterCircle;
@property (assign, nonatomic) NSInteger number; // you can override this to show other than percent number
@property (strong, nonatomic) NSString *word;   // you can overrode this to show other than default 'PRCNT' text

@property (assign, nonatomic) CGFloat startAngle;
@property (assign, nonatomic) CGFloat endAngle;

@property (strong, nonatomic) UIColor *circleBackgroundColor;
@property (strong, nonatomic) UIColor *circleProgressColor;
@property (strong, nonatomic) UIColor *circleOuterColor;
@property (strong, nonatomic) UIColor *textInsideCircleColor;

@end
