//
//  NSString+GDWTime.m
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "NSString+GDWTime.h"

@implementation NSString (GDWTime)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    time += 0.05;
    NSInteger min = time / 60;
    NSInteger second = (NSInteger)time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}


@end
