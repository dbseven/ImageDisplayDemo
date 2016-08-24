//
//  ProgressView.m
//  02_下载进度条
//
//  Created by CristianoRLong on 16/8/2.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (instancetype)init {
    if (self = [super init]) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.7f];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.7f];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    // setNeedsDisplay 底层就会调用 drawRect, 系统自动调用, 如果我们手动调用 drawRect 方法, 是无法拿到 context 的. 所以需要使用 setNeedsDisplay 方法
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint arcCenter = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - 10;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.progress * M_PI * 2;
    BOOL clockwise = YES;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter: arcCenter
                                                        radius: radius
                                                    startAngle: startAngle
                                                      endAngle: endAngle
                                                     clockwise: clockwise];
    
    [path addLineToPoint: arcCenter];
    
    [[[UIColor blackColor] colorWithAlphaComponent:0.8] setFill];
    
    [path fill];
}

@end
