//
//  GDWLrcCell.h
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GDWLrcLineModel;
@interface GDWLrcCell : UITableViewCell


/** 一句歌词模型 */
@property (nonatomic, strong) GDWLrcLineModel *lrcLine;
/** 歌词进度 */
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)lrcCellFromNib;
- (void)changeTextFont:(UIFont *)font;

@end
