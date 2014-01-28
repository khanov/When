//
//  SKProgressIndicator.h
//  Time Left
//
//  Created by Salavat Khanov on 1/21/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKProgressIndicator : UIView

@property (assign, nonatomic) NSInteger percentInnerCircle;
@property (assign, nonatomic) CGFloat percentOuterCircle;

@property (strong, nonatomic) UIColor *circleBackgroundColor;
@property (strong, nonatomic) UIColor *circleProgressColor;
@property (strong, nonatomic) UIColor *circleOuterColor;
@property (strong, nonatomic) UIColor *textInsideCircleColor;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;

@end
