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
static CGFloat kNumberInsideCircleFontSize = 35;
static NSString *kWordInsideCircleFontName = @"DINAlternate-Bold";
static CGFloat kWordInsideCircleFontSize = 12;
static CGFloat kMarginBetweenNumberAndWord = 2;

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
    // Determine our start and stop angles for the arc (in radians)
    self.startAngle = M_PI * 1.5;
    self.endAngle = self.startAngle + (M_PI * 2);
    // Defaults
    self.word = @"PRCNT";
    self.number = lroundf(self.percentCircle);
    [self setupColors];
}

- (void)setupColors
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:149/255.0 blue:0/255.0 alpha:1.0];
    self.circleBackgroundColor = [UIColor whiteColor];
    self.circleProgressColor = [UIColor colorWithRed:105/255.0 green:50/255.0 blue:0/255.0 alpha:1.0]; // dark orange
    self.circleOuterColor = [UIColor whiteColor];
    self.textInsideCircleColor = [UIColor whiteColor];
    
    //    self.backgroundColor = [UIColor colorWithRed:36/255.0 green:15/255.0 blue:46/255.0 alpha:1.0]; // night version
    //    self.circleBackgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
    //    self.circleProgressColor = [UIColor colorWithRed:80/255.0 green:54/255.0 blue:101/255.0 alpha:1.0]; // night version
    //    self.circleOuterColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
    //    self.textInsideCircleColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]; // night version
}

- (void)drawRect:(CGRect)rect
{
    // Draw circles
    [self drawInnerCircleBackgroundIn:rect];
    [self drawInnerCircleProgress:self.percentCircle inRect:rect];
    // Draw text
    [self drawTextInsideCircleInRect:rect];
}

- (void)drawInnerCircleBackgroundIn:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kCircleRadius
                      startAngle:0
                        endAngle:M_PI * 2
                       clockwise:YES];
    
    bezierPath.lineWidth = kCircleLineWidth;
    [self.circleBackgroundColor setStroke];
    [bezierPath stroke];
}

- (void)drawInnerCircleProgress:(CGFloat)percent inRect:(CGRect)rect
{
    CGFloat startAngle = M_PI * 1.5;
    CGFloat endAngle = startAngle + (M_PI * 2);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];

    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kCircleRadius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (percent / 100.0) + startAngle
                       clockwise:YES];

    bezierPath.lineWidth = kCircleLineWidth;
    [self.circleProgressColor setStroke];
    [bezierPath stroke];
}

- (void)drawTextInsideCircleInRect:(CGRect)rect
{
    NSString *numberString = [NSString stringWithFormat:@"%ld", self.number];
    NSString *wordString = self.word;
    
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
    
    NSAttributedString *numberAttrText = [[NSAttributedString alloc] initWithString:numberString attributes:numberAttributes];
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
