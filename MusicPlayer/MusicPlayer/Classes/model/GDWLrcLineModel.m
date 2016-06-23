//
//  GDWLrcLineModel.m
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWLrcLineModel.h"

@implementation GDWLrcLineModel

- (instancetype)initWithLrcString:(NSString *)lrclineString
{
    if (self = [super init]) {
        // [01:24.98]想你时你在心田
        NSArray *lrclineArray = [lrclineString componentsSeparatedByString:@"]"];
        self.text = [lrclineArray lastObject];
        self.time = [self timeWithTimeString:[lrclineArray[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)lrcLineWithLrcString:(NSString *)lrclineString
{
    return [[self alloc] initWithLrcString:lrclineString];
}

#pragma mark - 私有方法
- (NSTimeInterval)timeWithTimeString:(NSString *)timeString
{
    // 01:24.98
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    NSInteger min = [[timeArray firstObject] integerValue];
    // 24.98
    NSInteger second = [[[timeArray lastObject] componentsSeparatedByString:@"."][0] integerValue];
    NSInteger haomiao = [[[timeArray lastObject] componentsSeparatedByString:@"."][1] integerValue];
    
    return min * 60 + second + haomiao * 0.01;
}



@end
