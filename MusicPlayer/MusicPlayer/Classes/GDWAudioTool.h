//
//  GDWAudioTool.h
//  MusicPlayer
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GDWAudioTool : NSObject

// 播放音效
+ (void)playSoundWithSoundName:(NSString *)soundName;
//播放音乐
+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName;

+ (void)pauseMusicWithMusicName:(NSString *)musicName;

+ (void)stopMusicWithMusicName:(NSString *)musicName;

@end
