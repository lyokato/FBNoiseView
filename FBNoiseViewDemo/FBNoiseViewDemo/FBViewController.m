//
//  FBViewController.m
//  FBNoiseViewDemo
//
//  Created by Lyo Kato on 2013/11/14.
//  Copyright (c) 2013年 OCTUDIO. All rights reserved.
//

#import "FBViewController.h"
#import <FBNoiseView/FBGaussianNoiseView.h>
#import <FBNoiseView/FBRandomBlockNoiseView.h>

@interface FBViewController ()
@property (nonatomic) FBGaussianNoiseView *gaussianNoise;
@property (nonatomic) FBRandomBlockNoiseView *blockNoise;
@property (nonatomic) UIButton *button;
@property (nonatomic) BOOL isShowingGaussianNoise;
@end

@implementation FBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self setupBackground];

    [self setupBlockNoiseView];
    [self setupGaussianNoiseView];
    
    [self setupButton];
    
    self.isShowingGaussianNoise = YES;
    [self.gaussianNoise startNoise];

}

- (void)switchNoise
{
    if (self.isShowingGaussianNoise) {
        self.gaussianNoise.alpha = 0.0;
        [self.gaussianNoise stopNoise];
        [self.view bringSubviewToFront:self.blockNoise];
        [self.view bringSubviewToFront:self.button];
        [self.blockNoise startToAppear];
        self.isShowingGaussianNoise = NO;
    } else {
        [self.view bringSubviewToFront:self.gaussianNoise];
        [self.view bringSubviewToFront:self.button];
        [self.gaussianNoise startNoise];
        self.gaussianNoise.alpha = 0.6;
        [self.blockNoise startToDisappear];
        self.isShowingGaussianNoise = YES;
    }
}

- (void)setupBackground
{
    UIImage *image = [UIImage imageNamed:@"background.png"];
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    v.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:v];
}

- (void)setupGaussianNoiseView
{
    CGRect frame = CGRectMake(0, 0, 320, 568);
    FBGaussianNoiseView *v = [[FBGaussianNoiseView alloc] initWithFrame:frame];
    v.backgroundColor = UIColor.blackColor;
    v.alpha = 0.6;
    [self.view addSubview:v];
    self.gaussianNoise = v;
}

- (void)setupBlockNoiseView
{
    CGRect frame = CGRectMake(0, 0, 320, 568);
    FBRandomBlockNoiseView *v = [[FBRandomBlockNoiseView alloc] initWithFrame:frame];
    //v.backgroundColor = UIColor.blackColor;
    v.alpha = 0.6;
    [self.view addSubview:v];
    self.blockNoise = v;
}

- (void)setupButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    button.backgroundColor = UIColor.whiteColor;
    button.layer.cornerRadius = 8.0;
    [button setTitle:@"Click to Switch Noise" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.1 alpha:0.2]];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(onSwitchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
}

- (void)onSwitchButtonTapped:(id)selector
{
    [self switchNoise];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
