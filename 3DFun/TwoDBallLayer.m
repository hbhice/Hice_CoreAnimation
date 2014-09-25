//
//  TwoDBallLayer.m
//  3DFun
//
//  Created by HuangBing on 9/25/14.
//  Copyright (c) 2014 HuangBing. All rights reserved.
//

#import "TwoDBallLayer.h"
#import <UIKit/UIKit.h>

@implementation TwoDBallLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self != nil)
    {
        self.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor, nil];
        self.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil];
        self.frame = frame;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        //Set borders and cornerRadius
        //self.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.3]CGColor];
        self.cornerRadius = 10;
        //self.borderWidth = 1;
    
    }
    
    return self;
}

@end
