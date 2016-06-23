//
//  GDWLrcTool.m
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWLrcTool.h"
#import "GDWLrcLineModel.h"

@implementation GDWLrcTool

+ (NSArray *)lrcWithLrcName:(NSString *)lrcName
{
    // 1.将歌词读取出来
    NSString *filePath = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // 2.将一句句歌词进行切割
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    
    // 3.将歌词转成模型对象
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrclineString in lrcArray) {
        // 3.1.将不需要的歌词过滤掉
        if ([lrclineString hasPrefix:@"[ti:"] || [lrclineString hasPrefix:@"[ar:"] || [lrclineString hasPrefix:@"[al:"] || ![lrclineString hasPrefix:@"["]) continue;
        
        // 3.2.将需要的歌词转成模型对象
        GDWLrcLineModel *lrcLine = [GDWLrcLineModel lrcLineWithLrcString:lrclineString];
        
        // 3.3.将模型对象放入数组中
        [tempArray addObject:lrcLine];
    }
    
    return tempArray;
}

@end
