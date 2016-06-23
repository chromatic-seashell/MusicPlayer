//
//  GDWLrcLabe.m
//  MusicPlayer
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWLrcLabe.h"

@implementation GDWLrcLabe

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    [self  setNeedsDisplay];


}

- (void)drawRect:(CGRect)rect{

    [super  drawRect:rect];
    //设置上下文的颜色
    [[UIColor  greenColor]  set];
    
    //绘制矩形框
    CGRect  drawRect = CGRectMake(0, 0, rect.size.width*self.progress, rect.size.height);
    //绘制
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);

}





@end
