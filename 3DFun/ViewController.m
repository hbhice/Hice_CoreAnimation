//
//  ViewController.m
//  3DFun
//
//  Created by HuangBing on 9/25/14.
//  Copyright (c) 2014 HuangBing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"
#import "TwoDBallLayer.h"
#import "BCurveLayer.h"
#import "CardioidBezierCurve.h"

@interface ViewController ()

@property UIButton* mPauseButton;
@property UIButton* mResumeButton;
@property UIButton* mReAnimateButton;
@property CALayer* ballLayer;
@property CAShapeLayer* bCurveLayer;

@end

@implementation ViewController

@synthesize ballLayer, bCurveLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initButton];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self reAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton
{
    self.mPauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.mPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.mPauseButton setFrame:CGRectMake(100, 720, 90, 60)];
    [self.mPauseButton setBackgroundColor:[UIColor whiteColor]];
    [self.mPauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mPauseButton addTarget:self action:@selector(pauseAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mPauseButton];
    
    self.mResumeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.mResumeButton setTitle:@"Resume" forState:UIControlStateNormal];
    [self.mResumeButton setFrame:CGRectMake(240, 720, 90, 60)];
    [self.mResumeButton setBackgroundColor:[UIColor whiteColor]];
    [self.mResumeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mResumeButton addTarget:self action:@selector(resumeAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mResumeButton];
    
    self.mReAnimateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.mReAnimateButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self.mReAnimateButton setFrame:CGRectMake(380, 720, 90, 60)];
    [self.mReAnimateButton setBackgroundColor:[UIColor whiteColor]];
    [self.mReAnimateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mReAnimateButton addTarget:self action:@selector(reAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mReAnimateButton];

    
}

- (CGMutablePathRef)createBasicCurvePath
{
    // get the path for animation
    /*CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, 100, 100);
    CGPathAddCurveToPoint(thePath, NULL, 100, 500, 320, 500, 320, 100);
    CGPathAddCurveToPoint(thePath, NULL, 320, 500, 566, 500, 566, 100);
    return thePath;*/
    
    CardioidBezierCurve* bCurve = [[CardioidBezierCurve alloc] init];
    return [bCurve getBezierPath];
    

}

- (CGMutablePathRef)createLinePath
{
    // get the path for animation
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, 100, 100);
    CGPathAddLineToPoint(thePath, NULL, 566, 100);
    
    return thePath;
}


- (CALayer*)createBallLayer
{
    return [[TwoDBallLayer alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
}

- (CAShapeLayer*)createBCurveLayer:(CGMutablePathRef)path
{
    return [[BCurveLayer alloc] initWithFrame:CGRectMake(0, 0, 700, 700) andPath:path];
}

- (void)createKeyFrameAnimationForLayer:(CALayer*)layer withPath:(CGMutablePathRef)path withTime:(double)time
{
    // create animation
    CAKeyframeAnimation* keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = path;
    keyAnimation.duration = time;
    
    [layer addAnimation:keyAnimation forKey:@"position"];
    
    layer.position = CGPointMake(566, 100);
}

- (void)createPathAnimationForLayer:(CAShapeLayer*)layer withPath:(CGMutablePathRef)path withTime:(double)time
{
    // create animation
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)layer.path;
    pathAnimation.toValue = (__bridge id)path;
    pathAnimation.duration = time;
    
    [layer addAnimation:pathAnimation forKey:@"path"];
    
    [CATransaction setCompletionBlock:^{
        [layer setHidden:YES];
        [self.mReAnimateButton setEnabled:YES];
    }];

}

- (void)createPath2AnimationForLayer:(CAShapeLayer*)layer withPath:(CGMutablePathRef)path withTime:(double)time
{
    // create animation
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    pathAnimation.duration = time;
    
    [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    layer.strokeEnd = 1;
    
}

- (void)pauseAnimation
{
    [self pauseLayer:self.view.layer];
    [self pauseLayer:ballLayer];
    [self pauseLayer:bCurveLayer];
}

- (void)resumeAnimation
{
    [self resumeLayer:self.view.layer];
    [self resumeLayer:ballLayer];
    [self resumeLayer:bCurveLayer];
}

- (void)reAnimation
{
    CGMutablePathRef curvePath = [self createBasicCurvePath];
    
    if (ballLayer == nil)
    {
        ballLayer = [self createBallLayer];
        [self.view.layer addSublayer:ballLayer];
    }
    
    if (bCurveLayer == nil)
    {
        bCurveLayer = [self createBCurveLayer:curvePath];
        [self.view.layer addSublayer:bCurveLayer];
    }
    
    [self createKeyFrameAnimationForLayer:ballLayer withPath:curvePath withTime:5.0];
    [self createPath2AnimationForLayer:bCurveLayer withPath:curvePath withTime:5.0];
    
    CGPathRelease(curvePath);
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}



@end
