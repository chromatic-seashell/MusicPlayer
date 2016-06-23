//
//  GDWMusicTool.m
//  MusicPlayer
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWMusicTool.h"
#import "GDWMusicModel.h"
#import "MJExtension.h"

@implementation GDWMusicTool

static NSArray * _musics;
static GDWMusicModel * _playingMusic;

//第一次使用该类时调用
+ (void)initialize{
    _musics=[GDWMusicModel    objectArrayWithFilename:@"Musics.plist"];
    _playingMusic=_musics[2];
}

#pragma mark - 返回所有歌曲
+ (NSArray *)musics{
    return _musics;
}

#pragma mark -  操作正在播放歌曲
+ (GDWMusicModel *)playingMusic{
    return _playingMusic;
}

+ (void)setPlayingMusic:(GDWMusicModel *)playingMusic{

    _playingMusic=playingMusic;
}

#pragma mark - 上一首歌曲和下一首歌曲
+ (GDWMusicModel *)nextMusic{
    // 1.获取当前歌曲的下标志
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首歌曲的下标志
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex > _musics.count - 1) {
        nextIndex = 0;
    }
    
    // 3.取出下一首歌曲并且返回
    return _musics[nextIndex];

}
    
+ (GDWMusicModel *)previousMusic{
    // 1.获取当前歌曲的下标志
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首歌曲的下标志
    NSInteger previousIndex = currentIndex - 1;
    if (previousIndex < 0) {
        previousIndex = _musics.count-1;
    }
    
    // 3.取出下一首歌曲并且返回
    return _musics[previousIndex];
    
}


@end
