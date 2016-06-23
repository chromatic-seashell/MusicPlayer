//
//  GDWMusicCell.h
//  MusicPlayer
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GDWMusicModel;
@interface GDWMusicCell : UITableViewCell

/** 歌曲 */
@property (nonatomic, strong) GDWMusicModel *music;

@end
