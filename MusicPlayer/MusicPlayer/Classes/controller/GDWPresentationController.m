//
//  GDWPresentationController.m
//  MusicPlayer
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWPresentationController.h"

@interface GDWPresentationController ()

/* 挡板 */
@property (nonatomic,weak) UIView *maskView;

@end


@implementation GDWPresentationController


/** maskView懒加载 */
//- (UIView *)maskView{
//    if (!_maskView) {
//        UIView *maskView = [[UIView   alloc]  init];
//        self.maskView=maskView;
//    }
//    return _maskView;
//}
#pragma mark 手势监听
- (void)tapGestureClick:(UIGestureRecognizer *)gesture{

    [self.presentedViewController   dismissViewControllerAnimated:YES completion:nil];
}

- (void)containerViewWillLayoutSubviews{
 
    [super    containerViewWillLayoutSubviews];
    
    //1添加蒙版
    UIView *tempView=[[UIView  alloc]  init];

    tempView.frame=self.containerView.bounds;
    tempView.backgroundColor=GDWBackgroundColor;
    //给蒙版添加手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(tapGestureClick:)];
    [tempView  addGestureRecognizer:tapGesture];
    [self.containerView   insertSubview:tempView  atIndex:0];
    
   
    //2设置被展示视图的尺寸
    self.presentedView.frame=self.presentedFrame;
    

}


@end
