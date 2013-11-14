//
//  FBGaussianNoiseView.m
//  Flashback
//
//  Created by Lyo Kato on 13/08/20.
//  Copyright (c) 2013 Octudio. All rights reserved.
//
#import "FBGaussianNoiseView.h"
#import <QuartzCore/QuartzCore.h>

#define kNoiseImageName @"FBGaussianNoise.png"

@interface FBGaussianNoiseView ()
@property (nonatomic) NSArray *blockViews;
@property (nonatomic) UIImage *noiseImage;
@property (nonatomic) NSTimer *timer;
@end

@implementation FBGaussianNoiseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.noiseImage = [UIImage imageNamed:kNoiseImageName];
    [self setupBlocks];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startNoise
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)tick
{
    for (NSArray *columns in self.blockViews) {
        for (UIView *v in columns) {
            v.layer.transform = CATransform3DMakeRotation(M_PI_2 * (int)arc4random_uniform(4), 0.0, 0.0, 1.0);
        }
    }
}

- (void)stopNoise
{
    [self stopTimer];
}

- (void)setupBlocks
{
    CGSize ss = self.bounds.size;
    NSInteger numberOfColumns = ss.width / self.noiseImage.size.width + 1;
    NSInteger numberOfRows    = ss.height / self.noiseImage.size.height + 1;
    
    CGFloat xOffset = (numberOfColumns * self.noiseImage.size.width - ss.width)/2.0;
    CGFloat yOffset = (numberOfRows * self.noiseImage.size.height - ss.height)/2.0;
    
    NSMutableArray *rows = @[].mutableCopy;
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSMutableArray *columns = @[].mutableCopy;
        for (NSInteger j = 0; j < numberOfColumns; j++) {
            CGRect frame = CGRectMake(self.noiseImage.size.width * j - xOffset, self.noiseImage.size.height * i - yOffset, self.noiseImage.size.width, self.noiseImage.size.height);
            UIImageView *view = [[UIImageView alloc] initWithImage:self.noiseImage];
            view.frame = frame;
            //view.alpha = 0.0;
            [self addSubview:view];
            [columns addObject:view];
        }
        [rows addObject:columns];
    }
    self.blockViews = rows;
}

@end
