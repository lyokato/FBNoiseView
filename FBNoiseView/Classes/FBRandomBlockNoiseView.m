//
//  FBRandomBlockNoiseView.m
//  Flashback
//
//  Created by Lyo Kato on 2013/06/30.
//  Copyright (c) 2013 Octudio. All rights reserved.
//

#import "FBRandomBlockNoiseView.h"

#define kRefreshInterval   0.015
#define kMaxAlpha          0.9
#define kAnimationDuration 0.2

@interface FBRandomBlockNoiseView ()
@property (nonatomic) NSArray *blockViews;
@property (nonatomic) NSMutableArray *tmpViews;
@property (nonatomic) CGFloat blockWidth;
@property (nonatomic) CGFloat blockHeight;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger numberOfTransitionAtSingleTick;
@end

@implementation FBRandomBlockNoiseView

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
    self.backgroundColor = UIColor.clearColor;
    self.blockWidth = 30;
    self.blockHeight = 30;
    self.numberOfTransitionAtSingleTick = 4;
    self.tmpViews = @[].mutableCopy;
    [self setupBlocks];
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)startToAppear
{
    [self.tmpViews removeAllObjects];
    for (NSArray *columns in self.blockViews) {
        for (UIView *v in columns) {
            [self.tmpViews addObject:v];
        }
    }
    
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(tickToAppear)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)tickToAppear
{
    NSArray *views = [self nextTargetViews];
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UIView *v in views) {
            v.alpha = kMaxAlpha - arc4random_uniform(3) * 0.1;
        }
    } completion:nil];
    if (self.tmpViews.count == 0) {
        [self stopTimer];
        if ([self.delegate respondsToSelector:@selector(noiseViewDidAppear:)]) {
            [self.delegate noiseViewDidAppear:self];
        }
        [self startNoiseEffect];
    }
}

- (void)startNoiseEffect
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kRefreshInterval
                                                  target:self
                                                selector:@selector(tickToNoise)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)tickToNoise
{
    NSMutableArray *views = @[].mutableCopy;
    NSInteger numberOfRows = self.blockViews.count;
    NSInteger numberOfColumns = ((NSArray*)[self.blockViews objectAtIndex:0]).count;
    NSInteger numberOfViews = numberOfRows * numberOfColumns;
    
    NSInteger numberOfTarget = arc4random_uniform(4);
    for (NSInteger i = 0; i < numberOfTarget; i++) {
        NSInteger j = arc4random_uniform(numberOfViews);
        UIView *view = [((NSArray *)[self.blockViews objectAtIndex:j / numberOfColumns]) objectAtIndex:j % numberOfColumns];
        view.alpha = 0.5;
        [views addObject:view];
    }

    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UIView *v in views) {
            v.alpha = kMaxAlpha - arc4random_uniform(3) * 0.1;
        }
    } completion:nil];
}

- (void)tickToDisappear
{
    NSArray *views = [self nextTargetViews];
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UIView *v in views) {
            v.alpha = 0.0;
        }
    } completion:nil];
    if (self.tmpViews.count == 0) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([self.delegate respondsToSelector:@selector(noiseViewDidDisappear:)]) {
            [self.delegate noiseViewDidDisappear:self];
        }
        [self stopTimer];
    }
}

- (NSArray *)nextTargetViews
{
    NSMutableArray *targets = @[].mutableCopy;
    for (NSInteger i = 0; i < self.numberOfTransitionAtSingleTick; i++) {
        if (self.tmpViews.count > 0) {
            UIView *v = [self.tmpViews objectAtIndex: arc4random_uniform(self.tmpViews.count)];
            [self.tmpViews removeObject:v];
            [targets addObject:v];
        } else {
            break;
        }
    }
    return targets;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startToDisappear
{
    [self.tmpViews removeAllObjects];
    for (NSArray *columns in self.blockViews) {
        for (NSArray *v in columns) {
            [self.tmpViews addObject:v];
        }
    }
    
    [self stopTimer];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kRefreshInterval
                                                  target:self
                                                selector:@selector(tickToDisappear)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
    
}


- (void)setupBlocks
{
    CGSize ss = UIScreen.mainScreen.bounds.size;
    NSInteger numberOfColumns = ss.width / self.blockWidth + 1;
    NSInteger numberOfRows    = ss.height / self.blockHeight + 1;
    
    CGFloat xOffset = (numberOfColumns * self.blockWidth - ss.width)/2.0;
    CGFloat yOffset = (numberOfRows * self.blockHeight - ss.height)/2.0;
    
    NSMutableArray *rows = @[].mutableCopy;
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSMutableArray *columns = @[].mutableCopy;
        for (NSInteger j = 0; j < numberOfColumns; j++) {
            CGRect frame = CGRectMake(self.blockWidth * j - xOffset, self.blockHeight * i - yOffset, self.blockWidth, self.blockHeight);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = UIColor.blackColor;
            view.alpha = 0.0;
            [self addSubview:view];
            [columns addObject:view];
        }
        [rows addObject:columns];
    }
    self.blockViews = rows;
}

@end
