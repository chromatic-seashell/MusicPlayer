//
//  GDWLrcView.h
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDWLrcLabe,GDWLrcView;

@protocol GDWLrcViewDelegate <NSObject>

- (void)lrcView:(GDWLrcView *)lrcView   lockScreenImage:(UIImage *)image;

@end

@interface GDWLrcView : UIScrollView

/** 歌词的文件名称 */
@property (nonatomic, copy) NSString *lrcName;
/** 当前播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 单句歌词的lable */
@property (nonatomic,weak) GDWLrcLabe *singleLrcLable;

/** lrcView的代理 */
@property (nonatomic,weak) id <GDWLrcViewDelegate> lrcViewDelegate;

@end
