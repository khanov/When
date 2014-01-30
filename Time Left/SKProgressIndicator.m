//
//  SKProgressIndicator.m
//  Time Left
//
//  Created by Salavat Khanov on 1/21/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKProgressIndicator.h"
#import "SKAppDelegate.h"

static NSInteger kInnerCircleRadius = 117;
static NSInteger kInnnerCircleLineWidth = 22;
static NSInteger kOuterCircleRadius = 138;
static CGFloat kOuterCircleLineWidth = 2.5;

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
    [self setupColors];
}

- (void)setupColors
{
    SKAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSDictionary *colors = [delegate currentTheme];
    
    self.backgroundColor = [colors objectForKey:@"background"];
    self.innerCircleBackgroundColor = [colors objectForKey:@"innerCircleBackground"];
    self.innerCircleProgressColor = [colors objectForKey:@"innerCircleProgress"];
    self.outerCircleBackgroundColor = [colors objectForKey:@"outerCircleBackground"];
    self.outerCircleProgressColor = [colors objectForKey:@"outerCircleProgress"];
    self.textInsideCircleColor = [colors objectForKey:@"tint"];

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
    [self.innerCircleBackgroundColor setStroke];
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
    [self.innerCircleProgressColor setStroke];
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
    [self.outerCircleBackgroundColor setStroke];
    [bezierPath stroke];
}

- (void)drawOuterCircleProgress:(CGFloat)percent inRect:(CGRect)rect
{
    if (percent <= 100) {
        [self doneOuterCircleAnimation];
    } else {
        [self progressOuterCircleAnimation];
    }
}

- (void)progressOuterCircleAnimation
{
    CFTimeInterval rotateAnimationDuration = 1.0;
    CFTimeInterval rotateAnimationBeginTime = CACurrentMediaTime();
    CFTimeInterval strokeAnimationDuration = 0.35;
    CFTimeInterval strokeAnimationBeginTime = rotateAnimationBeginTime + (1.0 - strokeAnimationDuration);
    
    // Creating shape layer takes some time.
    // If the shape doesn't exist, create it and use different duration.
    if (self.outerCirclePathLayer == nil) {
        // Create
        CFTimeInterval start = CACurrentMediaTime();
        CGFloat startAngle = M_PI * 1.5;
        CGFloat endAngle = startAngle + (M_PI * 2);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                              radius:kOuterCircleRadius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = self.outerCircleProgressColor.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = kOuterCircleLineWidth;
        shapeLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:shapeLayer];
        self.outerCirclePathLayer = shapeLayer;
        CFTimeInterval finish = CACurrentMediaTime();
        
        // Recalculate duration time
        CFTimeInterval timeTook = finish - start;
        CFTimeInterval timeLeft = 1.0 - timeTook;
        rotateAnimationDuration = timeLeft;
        rotateAnimationBeginTime = finish;
        strokeAnimationBeginTime -= timeTook;
    }

    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:kRotationAnimationKey];
    rotateAnimation.duration = rotateAnimationDuration;
    rotateAnimation.repeatCount = INFINITY;
    rotateAnimation.fromValue = @(0.0f);
    rotateAnimation.toValue = @(1.0f);
    rotateAnimation.beginTime = rotateAnimationBeginTime;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotateAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:kColorAnimationKey];
    strokeAnimation.duration = strokeAnimationDuration;
    strokeAnimation.repeatCount = 0;
    strokeAnimation.autoreverses = NO;
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    strokeAnimation.fromValue = (id)self.outerCircleProgressColor.CGColor;
    strokeAnimation.toValue = (id)self.backgroundColor.CGColor;
    strokeAnimation.beginTime = strokeAnimationBeginTime;
    strokeAnimation.removedOnCompletion = YES;
    
    [self.outerCirclePathLayer addAnimation:rotateAnimation forKey:kRotationAnimationKey];
    [self.outerCirclePathLayer addAnimation:strokeAnimation forKey:kColorAnimationKey];
}

- (void)doneOuterCircleAnimation
{
    if (self.outerCirclePathLayer == nil) {
        CGFloat startAngle = M_PI * 1.5;
        CGFloat endAngle = startAngle + (M_PI * 2);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                              radius:kOuterCircleRadius
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.strokeColor = self.outerCircleProgressColor.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = kOuterCircleLineWidth;
        shapeLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:shapeLayer];
        self.outerCirclePathLayer = shapeLayer;
    }
    
    if ([self.outerCirclePathLayer animationForKey:kColorAnimationKey] == nil) {
        
        [self.outerCirclePathLayer removeAllAnimations];
        
        // Add new animation
        CGFloat duration = 0.8;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:kColorAnimationKey];
        strokeAnimation.duration = duration;
        strokeAnimation.repeatCount = INFINITY;
        strokeAnimation.autoreverses = YES;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        strokeAnimation.fromValue = (id)self.outerCircleProgressColor.CGColor;
        strokeAnimation.toValue = (id)self.outerCircleBackgroundColor.CGColor;
        strokeAnimation.removedOnCompletion = NO;
        
        [self.outerCirclePathLayer addAnimation:strokeAnimation forKey:kColorAnimationKey];
    }
}

@end
