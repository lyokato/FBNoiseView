//
//  FBRandomBlockNoiseView.h
//  Flashback
//
//  Created by Lyo Kato on 2013/06/30.
//  Copyright (c) 2013 Octudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBRandomBlockNoiseView;
@protocol FBRandomBlockNoiseViewDelegate <NSObject>
@optional
- (void)noiseViewDidAppear:(FBRandomBlockNoiseView *)noiseView;
- (void)noiseViewDidDisappear:(FBRandomBlockNoiseView *)noiseView;
@end

@interface FBRandomBlockNoiseView : UIView
@property (nonatomic, weak) id<FBRandomBlockNoiseViewDelegate> delegate;
@property (nonatomic) CGFloat blockWidth;
@property (nonatomic) CGFloat blockHeight;
@property (nonatomic) NSInteger numberOfTransitionAtSingleTick;
@property (nonatomic) CGFloat refreshInterval;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat maxBlockAlpha;
- (void)startToAppear;
- (void)startToDisappear;
@end
