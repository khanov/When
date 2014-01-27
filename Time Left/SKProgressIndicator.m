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

static NSString *kRotationAnimationKey = @"strokeEnd";
static NSString *kColorAnimationKey = @"strokeColor";

@interface SKProgressIndicator ()
@property (nonatomic, weak) CAShapeLayer *outerCirclePathLayer;
@end

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
    // Defaults
    self.word = @"PRCNT";
    self.number = self.percentInnerCircle;
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
    [self drawInnerCircleProgress:self.percentInnerCircle inRect:rect];
    [self drawOuterCircleBackgroundIn:rect];
    [self drawOuterCircleProgress:self.percentInnerCircle inRect:rect];
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
    
    // TODO: Gradients
    // http://stackoverflow.com/questions/20630653/apply-gradient-color-to-arc-created-with-uibezierpath
    
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
    if (percent >= 100) {
        [self doneOuterCircleAnimation];
    } else {
        [self progressOuterCircleAnimation];
    }
}

- (void)progressOuterCircleAnimation
{
    NSLog(@"In-progress animation");
    
    if (self.outerCirclePathLayer == nil) {
        NSLog(@"Animation doesn't exist. Create a new one.");
        
        CGFloat startAngle = M_PI * 1.5;
        CGFloat endAngle = startAngle + (M_PI * 2);
        CGFloat duration = 1.0;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                              radius:kOuterCircleRadius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = self.circleProgressColor.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = kOuterCircleLineWidth;
        shapeLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:shapeLayer];
        self.outerCirclePathLayer = shapeLayer;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:kRotationAnimationKey];
        pathAnimation.duration = duration;
        pathAnimation.repeatCount = INFINITY;
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(1.0f);
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.outerCirclePathLayer addAnimation:pathAnimation forKey:kRotationAnimationKey];
    }
}

- (void)doneOuterCircleAnimation
{
    NSLog(@"Done animation");
    
    if ([self.outerCirclePathLayer animationForKey:kColorAnimationKey] == nil) {
        NSLog(@"Animation doesn't exist. Create a new one.");
        
        // Remove old animation
        [self.outerCirclePathLayer removeAnimationForKey:kRotationAnimationKey];
        [self.outerCirclePathLayer removeFromSuperlayer];
        
        // Add new animation
        CGFloat startAngle = M_PI * 1.5;
        CGFloat endAngle = startAngle + (M_PI * 2);
        CGFloat duration = 2.0;
        
        UIBezierPath *circleBezierPath = [UIBezierPath bezierPath];
        
        [circleBezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                              radius:kOuterCircleRadius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = circleBezierPath.CGPath;
        shapeLayer.strokeColor = self.circleProgressColor.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = kOuterCircleLineWidth;
        shapeLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:shapeLayer];
        self.outerCirclePathLayer = shapeLayer;
        
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:kColorAnimationKey];
        strokeAnimation.duration = duration;
        strokeAnimation.repeatCount = INFINITY;
        strokeAnimation.autoreverses = YES;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        strokeAnimation.fromValue = (id)self.circleProgressColor.CGColor;
        strokeAnimation.toValue = (id)self.circleBackgroundColor.CGColor;
        
        [shapeLayer addAnimation:strokeAnimation forKey:kColorAnimationKey];
    }
}

#pragma mark - Draw Texts

- (void)drawTextInsideCircleInRect:(CGRect)rect
{
    NSString *numberString = [NSString stringWithFormat:@"%ld", (long)self.number];
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
