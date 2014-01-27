//
//  SKEventCell.m
//  Time Left
//
//  Created by Salavat Khanov on 1/23/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKEventCell.h"

@interface SKEventCell ()
@property (strong, nonatomic) CAAnimation *quiveringAnimation;
@end

@implementation SKEventCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.deleteButton.hidden = YES;
}

- (void)startQuivering
{
    NSLog(@"Start quivering called.");
    // do not create animation if it is already animated
    if (!self.quiveringAnimation) {
        NSLog(@"Create cuivering animation.");
        self.deleteButton.hidden = NO;
    
        CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        CGFloat startAngle = (-2) * M_PI/180.0;
        CGFloat stopAngle = -startAngle;
        quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
        quiverAnim.toValue = [NSNumber numberWithFloat:2 * stopAngle];
        quiverAnim.autoreverses = YES;
        quiverAnim.duration = 0.12;
        quiverAnim.repeatCount = HUGE_VALF;
        CGFloat timeOffset = (arc4random() % 100)/100.0 - 0.50;
        quiverAnim.timeOffset = timeOffset;
        self.quiveringAnimation = quiverAnim;
    }
    NSLog(@"Quivering animation added.");
    [self.layer addAnimation:self.quiveringAnimation forKey:@"quivering"];
}

- (void)stopQuivering
{
    NSLog(@"Stop quivering called.");
    if (self.quiveringAnimation) {
        self.quiveringAnimation = nil;
        self.deleteButton.hidden = YES;
        [self.layer removeAnimationForKey:@"quivering"];
        NSLog(@"Quiverig animation removed");
    }
}

@end
