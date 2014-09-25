//
//  BCurveLayer.m
//  3DFun
//
//  Created by HuangBing on 9/25/14.
//  Copyright (c) 2014 HuangBing. All rights reserved.
//

#import "BCurveLayer.h"
#import <UIKit/UIKit.h>

@implementation BCurveLayer

- (id)initWithFrame:(CGRect)frame andPath:(CGMutablePathRef)path
{
    self = [super init];
    if (self != nil)
    {
        self.strokeColor = [UIColor redColor].CGColor;
        self.frame = frame;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.path = path;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeStart = 0;
        self.strokeEnd = 0;
        
    }
    
    return self;
}

@end
