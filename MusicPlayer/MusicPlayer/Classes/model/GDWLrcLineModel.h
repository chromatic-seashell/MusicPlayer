//
//  GDWLrcLineModel.h
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDWLrcLineModel : NSObject


/** 该句歌词开始的时间 */
@property (nonatomic, assign) NSTimeInterval time;

/** 歌词的文字 */
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithLrcString:(NSString *)lrclineString;
+ (instancetype)lrcLineWithLrcString:(NSString *)lrclineString;


@end
