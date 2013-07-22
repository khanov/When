//
//  SKBackgroundView.m
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import "SKBackgroundView.h"

@interface SKBackgroundView ()

@property (nonatomic, strong) UIImage *noizeImage;
- (void)loadNoizeImage;

@end


@implementation SKBackgroundView

@synthesize noizeImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNoizeImage];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];   
    [self loadNoizeImage];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        size_t num_locations            = 2;
        CGFloat locations[2]            = {0.1, 0.9};
        CGFloat colorComponents[8]      = {32.0/255.0, 36.0/255.0, 41.0/255.0, 1.0,
            68.0/255.0, 68.0/255.0, 68.0/255.0, 1.0};
        CGColorSpaceRef myColorspace    = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient          = CGGradientCreateWithColorComponents (myColorspace, colorComponents, locations, num_locations);
        
        CGPoint centerPoint             = CGPointMake(self.bounds.size.width / 2.0,
                                                      self.bounds.size.height / 2.0);
        
        // Draw the gradient
        CGContextDrawRadialGradient(context, gradient, centerPoint, rect.size.height / 2, centerPoint, 0, (kCGGradientDrawsBeforeStartLocation));
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(myColorspace);
    }
    CGContextRestoreGState(context);
    
    // Blend the noize texture to the background
    CGSize textureSize                  = [noizeImage size];
    CGContextDrawTiledImage(context, CGRectMake(0, 0, textureSize.width, textureSize.height), noizeImage.CGImage);
}

- (void)loadNoizeImage
{
    self.noizeImage = [UIImage imageNamed:@"noise.png"];
}


@end
