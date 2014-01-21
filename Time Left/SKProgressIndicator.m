//
//  SKProgressIndicator.m
//  Time Left
//
//  Created by Salavat Khanov on 1/21/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKProgressIndicator.h"

static NSInteger kInnerCircleRadius = 117;
static NSInteger kInnnerCircleLineWidth = 22;
static NSInteger kOuterCircleRadius = 138;
static CGFloat kOuterCircleLineWidth = 2.5;

static NSString *kTextInCircleFontName = @"DINAlternate-Bold";
static CGFloat kTextInCircleFontSize = 70;

@implementation SKProgressIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Determine our start and stop angles for the arc (in radians)
    self.startAngle = M_PI * 1.5;
    self.endAngle = self.startAngle + (M_PI * 2);
    self.percent = 28;
    
    [self setupColors];
}

- (void)setupColors
{
    self.circleBackgroundColor = [UIColor whiteColor];
    self.circleProgressColor = [UIColor colorWithRed:139/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
    self.circleOuterColor = [UIColor whiteColor];
    self.textInsideCircleColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
    [self drawInnerCircleBackgroundIn:rect];
    [self drawInnerCircleProgress:self.percent inRect:rect];
    [self drawOuterCircleBackgroundIn:rect];
    [self drawOuterCircleProgress:self.percent+20 inRect:rect];
    [self drawTextInsideCircleInRect:rect];
}

#pragma mark - Draw Circles

- (void)drawInnerCircleBackgroundIn:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kInnerCircleRadius
                      startAngle:0
                        endAngle:M_PI * 2
                       clockwise:YES];
    
    bezierPath.lineWidth = kInnnerCircleLineWidth;
    [self.circleBackgroundColor setStroke];
    [bezierPath stroke];
}

- (void)drawInnerCircleProgress:(CGFloat)percent inRect:(CGRect)rect
{
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + (M_PI * 2);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kInnerCircleRadius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (percent / 100.0) + startAngle
                       clockwise:YES];
    
    bezierPath.lineWidth = kInnnerCircleLineWidth;
    [self.circleProgressColor setStroke];
    [bezierPath stroke];
}

- (void)drawOuterCircleBackgroundIn:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kOuterCircleRadius
                      startAngle:0
                        endAngle:M_PI * 2
                       clockwise:YES];
    
    bezierPath.lineWidth = kOuterCircleLineWidth;
    [self.circleOuterColor setStroke];
    [bezierPath stroke];
}

- (void)drawOuterCircleProgress:(CGFloat)percent inRect:(CGRect)rect
{
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + (M_PI * 2);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kOuterCircleRadius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (percent / 100.0) + startAngle
                       clockwise:YES];
    
    bezierPath.lineWidth = kOuterCircleLineWidth;
    [self.circleProgressColor setStroke];
    [bezierPath stroke];
}

#pragma mark - Draw Texts

- (void)drawTextInsideCircleInRect:(CGRect)rect
{
    // Display our percentage as a string
    NSString *text = [NSString stringWithFormat:@"%ld", self.percent];
    
    UIFont *font = [UIFont fontWithName:kTextInCircleFontName size:kTextInCircleFontSize];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : self.textInsideCircleColor,
                                  NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    CGFloat textWidth = attrText.size.width;
    CGFloat textHeight = attrText.size.height;
    CGRect textRect = CGRectMake((rect.size.width / 2.0) - textWidth/2.0, (rect.size.height / 2.0) - textHeight/2.0, textWidth, textHeight);
    
    [attrText drawInRect:textRect];
}

@end
