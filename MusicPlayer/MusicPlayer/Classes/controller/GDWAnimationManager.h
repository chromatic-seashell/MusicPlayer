//
//  GDWAnimationManager.h
//  MusicPlayer
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDWAnimationManager : UIPresentationController<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>


/** 被展示视图尺寸 */
@property (nonatomic, assign) CGRect  presentedFrame;

@end
