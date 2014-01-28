//
//  SKEventCellProgressView.m
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEventCellProgressView.h"

static NSInteger kCircleRadius = 49;
static NSInteger kCircleLineWidth = 12;

static NSString *kNumberInsideCircleFontName = @"DINAlternate-Bold";
static NSString *kMetaTextFontName = @"DINAlternate-Bold";
static CGFloat kMetaTextFontSizeDefault = 12.0;
static CGFloat kMetaTextFontSizeSmall = 10.0;

@implementation SKEventCellProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupColors];
}

- (void)setupColors
{
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0/255.0 alpha:1.0];
    self.circleBackgroundColor = [UIColor whiteColor];
    self.circleProgressColor = [UIColor colorWithRed:105.0/255.0 green:50.0/255.0 blue:0/255.0 alpha:1.0]; // dark orange
    self.textInsideCircleColor = [UIColor whiteColor];
    
//        self.backgroundColor = [UIColor colorWithRed:36/255.0 green:15/255.0 blue:46/255.0 alpha:1.0]; // night version
//        self.circleBackgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
//        self.circleProgressColor = [UIColor colorWithRed:80/255.0 green:54/255.0 blue:101/255.0 alpha:1.0]; // night version
//        self.circleOuterColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
//        self.textInsideCircleColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
}

- (void)drawRect:(CGRect)rect
{
    // Draw circles
//    [self drawInnerCircleBackgroundIn:rect];
//    if (self.percentCircle < 100) {
//        [self drawInnerCircleProgress:self.percentCircle inRect:rect];
//    }
    
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + (M_PI * 2.0);
    
    // Draw background
    UIBezierPath *backgroundBezierPath = [UIBezierPath bezierPath];
    [backgroundBezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kCircleRadius
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    backgroundBezierPath.lineWidth = kCircleLineWidth;
    self.percentCircle < 100 ? [self.circleBackgroundColor setStroke] : [self.circleProgressColor setStroke];
    [backgroundBezierPath stroke];
    
    // Draw progess
    if (self.percentCircle < 100) {
        UIBezierPath *progressBezierPath = [UIBezierPath bezierPath];
        [progressBezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                                      radius:kCircleRadius
                                  startAngle:startAngle
                                    endAngle:(endAngle - startAngle) * (self.percentCircle / 100.0) + startAngle
                                   clockwise:YES];
        progressBezierPath.lineWidth = kCircleLineWidth;
        [self.circleProgressColor setStroke];
        [progressBezierPath stroke];
    }
}

- (void)useSmallerFont
{
    self.metaLabel.font = [UIFont fontWithName:kMetaTextFontName size:kMetaTextFontSizeSmall];
}

- (void)useDefaultFont
{
    self.metaLabel.font = [UIFont fontWithName:kMetaTextFontName size:kMetaTextFontSizeDefault];
}

@end
