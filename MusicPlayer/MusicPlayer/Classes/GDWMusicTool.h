//
//  GDWMusicTool.h
//  MusicPlayer
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDWMusicModel;

@interface GDWMusicTool : NSObject

#pragma mark - 返回所有歌曲
+ (NSArray *)musics;

#pragma mark -  操作正在播放歌曲
+ (GDWMusicModel *)playingMusic;

+ (void)setPlayingMusic:(GDWMusicModel *)playingMusic;

#pragma mark - 上一首歌曲和下一首歌曲
+ (GDWMusicModel *)nextMusic;

+ (GDWMusicModel *)previousMusic;


@end
