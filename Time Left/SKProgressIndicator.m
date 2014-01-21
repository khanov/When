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

static NSString *kNumberInsideCircleFontName = @"DINAlternate-Bold";
static CGFloat kNumberInsideCircleFontSize = 70;
static NSString *kWordInsideCircleFontName = @"DINAlternate-Bold";
static CGFloat kWordInsideCircleFontSize = 15;
static CGFloat kMarginBetweenNumberAndWord = 12;

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
    // Draw circles
    [self drawInnerCircleBackgroundIn:rect];
    [self drawInnerCircleProgress:self.percent inRect:rect];
    [self drawOuterCircleBackgroundIn:rect];
    [self drawOuterCircleProgress:self.percent+20 inRect:rect];
    // Draw texts
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
    NSString *numberSting = [NSString stringWithFormat:@"%ld", self.percent];
    NSString *wordString = @"PRCNT";
    
    UIFont *fontForNumber = [UIFont fontWithName:kNumberInsideCircleFontName size:kNumberInsideCircleFontSize];
    UIFont *fontForWord = [UIFont fontWithName:kWordInsideCircleFontName size:kWordInsideCircleFontSize];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *numberAttributes = @{ NSForegroundColorAttributeName : self.textInsideCircleColor,
                                        NSFontAttributeName : fontForNumber,
                                        NSParagraphStyleAttributeName : paragraphStyle};
    
    NSDictionary *wordAttributes = @{ NSForegroundColorAttributeName : self.textInsideCircleColor,
                                      NSFontAttributeName : fontForWord,
                                      NSParagraphStyleAttributeName : paragraphStyle};
    
    NSAttributedString *numberAttrText = [[NSAttributedString alloc] initWithString:numberSting attributes:numberAttributes];
    NSAttributedString *wordAttrText = [[NSAttributedString alloc] initWithString:wordString attributes:wordAttributes];
    
    // Sizes
    CGFloat numberWidth = numberAttrText.size.width;
    CGFloat numberHeight = numberAttrText.size.height;
    CGFloat wordWidth = wordAttrText.size.width;
    CGFloat wordHeight = wordAttrText.size.height;
    CGFloat margin = kMarginBetweenNumberAndWord;
    
    // Draw number inside the circle
    CGRect numberRect = CGRectMake((rect.size.width / 2.0) - (numberWidth / 2.0),
                                   (rect.size.height / 2.0) - (numberHeight + margin + wordHeight) / 2.0,
                                   numberWidth,
                                   numberHeight);
    [numberAttrText drawInRect:numberRect];
    
    // Draw word below the number
    CGRect wordRect = CGRectMake((rect.size.width / 2.0) - (wordWidth / 2.0),
                                   numberRect.origin.y + numberHeight / 2.0 + wordHeight + margin,
                                   wordWidth,
                                   wordHeight);
    [wordAttrText drawInRect:wordRect];
}

@end
