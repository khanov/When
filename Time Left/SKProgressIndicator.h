//
//  SKProgressIndicator.h
//  Time Left
//
//  Created by Salavat Khanov on 1/21/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKProgressIndicator : UIView

@property (assign, nonatomic) CGFloat startAngle;
@property (assign, nonatomic) CGFloat endAngle;
@property (assign, nonatomic) NSInteger percent;


@property (strong, nonatomic) UIColor *circleBackgroundColor;
@property (strong, nonatomic) UIColor *circleProgressColor;
@property (strong, nonatomic) UIColor *circleOuterColor;

@property (strong, nonatomic) UIColor *textInsideCircleColor;

@end
