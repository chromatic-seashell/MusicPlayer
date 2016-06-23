//
//  GDWAnimationManager.m
//  MusicPlayer
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWAnimationManager.h"
#import "GDWPresentationController.h"

@interface GDWAnimationManager ()

/** 是否被展示 */
@property (nonatomic, assign) BOOL isPresent;
@end

@implementation GDWAnimationManager


#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    GDWPresentationController *presentationController=[[GDWPresentationController alloc]  initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.presentedFrame=self.presentedFrame;
    
    return presentationController;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresent=YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresent=NO;
    return self;
}



#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .1;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresent) {
        //1.展现
        UIView *toView=[transitionContext  viewForKey:UITransitionContextToViewKey];
        [[transitionContext   containerView]  addSubview:toView];
        //2.执行动画
        toView.transform=CGAffineTransformMakeScale(1.0, 0);
        toView.layer.anchorPoint=CGPointMake(.5, 1);
        [UIView  animateWithDuration:[self  transitionDuration:transitionContext] animations:^{
            
            toView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [transitionContext  completeTransition:YES];
        }];
        
    }else{
    
        //1.展现
        UIView *fromView=[transitionContext  viewForKey:UITransitionContextFromViewKey];
        [[transitionContext   containerView]  addSubview:fromView];
        //2.执行动画
//        fromView.transform=CGAffineTransformMakeScale(1.0, 0);
//        fromView.layer.anchorPoint=CGPointMake(.5, 1);
        [UIView  animateWithDuration:[self  transitionDuration:transitionContext] animations:^{
            
            fromView.transform=CGAffineTransformMakeScale(1.0, 0);
        } completion:^(BOOL finished) {
            
            [transitionContext  completeTransition:YES];
        }];
    
    
    }
}

@end
