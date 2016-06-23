//
//  GDWMusicModel.h
//  MusicPlayer
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDWMusicModel : NSObject

/** 歌曲的名字 */
@property (nonatomic, copy) NSString *name;
/** 歌曲对应文件名称 */
@property (nonatomic, copy) NSString *filename;
/** 歌词的名称 */
@property (nonatomic, copy) NSString *lrcname;
/** 歌手的名称 */
@property (nonatomic, copy) NSString *singer;
/** 歌手对应的图标 */
@property (nonatomic, copy) NSString *singerIcon;
/** 歌手对应的封面 */
@property (nonatomic, copy) NSString *icon;

@end
