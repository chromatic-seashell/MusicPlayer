//
//  GDWMusicViewController.m
//  MusicPlayer
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWMusicViewController.h"
#import "GDWMusicTool.h"
#import "GDWAudioTool.h"
#import "GDWMusicModel.h"

#import "NSString+GDWTime.h"
#import "CALayer+GDWAnimation.h"
#import "Masonry.h"

#import "GDWLrcView.h"
#import "GDWLrcLabe.h"

#import <MediaPlayer/MediaPlayer.h>

//上拉菜单
#import "GDWMusicUpMenuController.h"
#import "GDWAnimationManager.h"

/** 歌词时间精度误差 */
#define lrcTimeTolerance  .1

@interface GDWMusicViewController ()<UIScrollViewDelegate,GDWLrcViewDelegate>

// 基本控件
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 播放或暂停按钮*/
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;


// 进度条
@property (weak, nonatomic) IBOutlet UISlider *progressBar;

// 显示歌词的View
@property (weak, nonatomic) IBOutlet GDWLrcView *lrcView;
// 歌词的Label
@property (weak, nonatomic) IBOutlet GDWLrcLabe *lrcLabel;

/* 当前音乐播放器 */
@property (nonatomic,weak) AVAudioPlayer *currentPlayer;
/* 进度的定时器 */
@property (nonatomic,strong) NSTimer *progressTimer;
/* 歌词的定时器 */
@property (nonatomic,weak) CADisplayLink *lrcTimer;

/** 上拉菜单代理 */
@property (nonatomic, strong) GDWAnimationManager *animationManager;

@end

@implementation GDWMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加毛玻璃效果.
    [self   setUpBlurGlassEffect];
    //2.设置滑动条的滑块
    [self.progressBar  setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    //3.开始播放音乐
    [self   startPlayingMusic];
    
    //4.将控制器的lable传递给lrcView的lable
    self.lrcView.singleLrcLable=self.lrcLabel;
    
    //5.设置lrcView的代理
    self.lrcView.lrcViewDelegate=self;
    
    //6.注册通知观察者
    [self  setUpObServer];
    
    
}
#pragma mark - 初始化操作

#pragma mark 背景图片添加毛玻璃效果.
- (void)setUpBlurGlassEffect{
   //方案1:UIToolbar
    //创建toolBar
    UIToolbar *toolBar=[[UIToolbar  alloc]  init];
    toolBar.barStyle=UIBarStyleBlack;
    [self.bgImageView   addSubview:toolBar];
    //设置约束
    [toolBar   mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.bgImageView);
    }];
}
#pragma mark 设置状态条样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillLayoutSubviews{
    [super  viewWillLayoutSubviews];
    CALayer *layer=self.iconView.layer;
    layer.cornerRadius=self.iconView.frame.size.width*.5;
    layer.borderWidth=8.0;
    layer.borderColor=[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0].CGColor;
    layer.masksToBounds=YES;
    
}

#pragma mark - 开始播放音乐
- (void)startPlayingMusic{
     //1.取出当前播放歌曲
    GDWMusicModel *playingMusic=[GDWMusicTool  playingMusic];
    //2.改变界面信息
    self.bgImageView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    //3.播放对应的歌曲,设置进度条的时间
    AVAudioPlayer *currentPlayer=[GDWAudioTool    playMusicWithMusicName:playingMusic.filename];
    self.currentPlayer=currentPlayer;
    self.currentTimeLabel.text=[NSString   stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text=[NSString   stringWithTime:currentPlayer.duration];
    //4.定时器
    [self   stopProgressTimer];
    [self   startProgressTimer];
    //5.给iconView添加动画
    [self   setUpIconViewAnimation];
    //6.将歌词传递给GDWLrcView
    self.lrcView.lrcName=playingMusic.lrcname;
    
    //7.更新歌词时间
    [self  stopLrcTimer];
    [self  startLrcTimer];
    
    //8.设置锁屏界面的信息
    [self  setUpLockScreenInfo:[UIImage  imageNamed:[GDWMusicTool  playingMusic].icon]];
    
}

#pragma mark - 定时器相关的操作
- (void)startProgressTimer{
    /*
     1.[NSTimer  scheduledTimerWithTimeInterval:(NSTimeInterval) target:(nonnull id) selector:(nonnull SEL) userInfo:(nullable id) repeats:(BOOL)];
     会自动将定时器加入runloop
     
     */
    //先更新进度条状态
    [self   updateProgressInfo];
    //开启定时器
    self.progressTimer=[NSTimer   timerWithTimeInterval:1 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop  mainRunLoop]   addTimer:self.progressTimer forMode:NSRunLoopCommonModes];

}
- (void)updateProgressInfo{
    //1.更新进度条值
    self.progressBar.value=self.currentPlayer.currentTime/self.currentPlayer.duration;
    //2.更新当前时间的lable
    self.currentTimeLabel.text=[NSString   stringWithTime:self.currentPlayer.currentTime];
}
- (void)stopProgressTimer{
    [self.progressTimer  invalidate];
}
#pragma mark - icon头像动画
- (void)setUpIconViewAnimation{
    //创建动画
    CABasicAnimation *basicAnim=[CABasicAnimation   animation];
    basicAnim.keyPath=@"transform.rotation";
    basicAnim.fromValue=@(0);
    basicAnim.toValue=@(M_PI*2);
    basicAnim.duration=35;
    basicAnim.repeatCount=MAXFLOAT;

    //添加动画
    [self.iconView.layer   addAnimation:basicAnim forKey:nil];
}
#pragma mark 歌词定时器
- (void)startLrcTimer{
    CADisplayLink *lrcTimer=[CADisplayLink   displayLinkWithTarget:self selector:@selector(updateLrc)];
    [lrcTimer  addToRunLoop:[NSRunLoop  mainRunLoop] forMode:NSRunLoopCommonModes];
    self.lrcTimer=lrcTimer;
    
}
- (void)stopLrcTimer{
    [self.lrcTimer  invalidate];
}
- (void)updateLrc{
    //1.获取歌曲的播放时间.
    self.lrcView.currentTime=self.currentPlayer.currentTime;
    
    //2.当一首歌曲播放完成后.自动播放下一首歌曲.
    /*
       1.NSLog(@"%d",self.currentPlayer.isPlaying);
       如果通过self.currentPlayer.isPlaying判断,当暂停的时候会出现bug
       2.
    */
    if (self.currentPlayer.currentTime+lrcTimeTolerance>=self.currentPlayer.duration) {
        [self  nextMusic:nil];
    }
}

#pragma mark - 对歌曲播放的控制
- (IBAction)playOrPause:(UIButton *)sender {
    BOOL  flag =  self.currentPlayer.isPlaying;
    if (flag) {//正在播放
        //1.改变按钮的状态
        sender.selected=NO;
        //2.暂停播放
        [self.currentPlayer  pause];
        //3.停止定时器
        [self   stopProgressTimer];
        //4.停止动画
        [self.iconView.layer  pauseAnimate];
    }else{
        //1.改变按钮的状态
        sender.selected=YES;
        //2.暂停播放
        [self.currentPlayer  play];
        //3.停止定时器
        [self   startProgressTimer];
        //4.停止动画
        [self.iconView.layer  resumeAnimate];
    
    }
}

- (IBAction)previousMusic:(UIButton *)sender {
    //如果动画停止,开启动画.
    if (self.iconView.layer.speed==0) {
        [self.iconView.layer  resumeAnimate];
    }
    //切换歌曲
    [self   changeMusic:[GDWMusicTool  previousMusic]];
}
- (IBAction)nextMusic:(UIButton *)sender {
    //如果动画停止,开启动画.
    if (self.iconView.layer.speed==0) {
        [self.iconView.layer  resumeAnimate];
    }
    //切换歌曲
    [self   changeMusic:[GDWMusicTool  nextMusic]];
    
}
- (void)changeMusic:(GDWMusicModel *)music
{
     //1.停止当前播放歌曲
    GDWMusicModel *playingMusic=[GDWMusicTool   playingMusic];
    [GDWAudioTool   stopMusicWithMusicName:playingMusic.filename];
    //2.切换歌曲
    [GDWMusicTool   setPlayingMusic:music];
    //3.开始播放歌曲
    [self   startPlayingMusic];
}

#pragma mark - 对歌曲进度条的操作
- (IBAction)sliderTouchDown:(UISlider *)sender {
    //停止定时器
    [self  stopProgressTimer];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    //更改当前时间
    self.currentTimeLabel.text=[NSString  stringWithTime:self.progressBar.value*self.currentPlayer.duration];
    
}

- (IBAction)sliderTouchUpInside:(UISlider *)sender {
    //1.更改播放器的时间
    self.currentPlayer.currentTime=self.progressBar.value*self.currentPlayer.duration;
    //2.开启定时器
    [self   startProgressTimer];
}

- (IBAction)sliderTapGesture:(UITapGestureRecognizer *)sender {
    //点击点在手势view中的位置
    CGPoint tapPoint=[sender  locationInView:sender.view];
    CGFloat scale=tapPoint.x/self.progressBar.frame.size.width;
    //更改滑动条的值
    self.progressBar.value=scale;
    //更改播放时间
    self.currentPlayer.currentTime=scale*self.currentPlayer.duration;
    //更新时间标签
    [self   updateProgressInfo];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //1.当前的滚动比例
    CGFloat scale=scrollView.contentOffset.x/scrollView.frame.size.width;
    // 2.设置iconView和歌词的Label的透明度
    self.iconView.alpha = 1 - scale;
    self.lrcLabel.alpha = 1 - scale;

}

#pragma mark - 设置锁屏界面信息
- (void)setUpLockScreenInfo:(UIImage *)lockScreenImage{
    // MPMediaItemPropertyAlbumTitle
    // MPMediaItemPropertyAlbumTrackCount
    // MPMediaItemPropertyAlbumTrackNumber
    // MPMediaItemPropertyArtist
    // MPMediaItemPropertyArtwork
    // MPMediaItemPropertyComposer
    // MPMediaItemPropertyDiscCount
    // MPMediaItemPropertyDiscNumber
    // MPMediaItemPropertyGenre
    // MPMediaItemPropertyPersistentID
    // MPMediaItemPropertyPlaybackDuration
    // MPMediaItemPropertyTitle
    //1.获取当前播放的歌曲
    GDWMusicModel *playingMusic=[GDWMusicTool  playingMusic];
    
    //2.获取锁屏中心
    MPNowPlayingInfoCenter *center  = [MPNowPlayingInfoCenter  defaultCenter];
    //3.设置显示的信息
    NSMutableDictionary *info = [NSMutableDictionary   dictionary];
    //3.1歌曲名
    [info  setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    //3.2歌手名
    [info  setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    //3.3歌曲总时长
    [info  setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    //3.4设置封面
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork   alloc]  initWithImage:lockScreenImage];
    [info    setObject:artWork forKey:MPMediaItemPropertyArtwork];
    
    center.nowPlayingInfo=info;
    //应用程序接受远程事件
    [[UIApplication  sharedApplication]   beginReceivingRemoteControlEvents];
}
#pragma mark 处理锁屏界面的远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self   playOrPause:self.playOrPauseBtn];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self   nextMusic:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self   previousMusic:nil];
            break;
        default:
            break;
    }

}

#pragma mark - lrcView的代理方法
- (void)lrcView:(GDWLrcView *)lrcView lockScreenImage:(UIImage *)image{

    [self  setUpLockScreenInfo:image];
}

#pragma mark - 设置观察者
- (void)setUpObServer{
    [[NSNotificationCenter  defaultCenter]  addObserver:self selector:@selector(playSeletedMusic:) name:GDWSeletedMusicNotification object:nil];

}
- (void)playSeletedMusic:(NSNotification *)notification{
    GDWMusicModel *music =notification.userInfo[@"seletedMusic"];
    [self  changeMusic:music];
}
- (void)dealloc{
    [[NSNotificationCenter  defaultCenter]   removeObserver:self];
}

#pragma mark - 上拉展示歌曲的菜单
/** _animationManager懒加载 */
- (GDWAnimationManager *)animationManager{
    if (!_animationManager) {
        self.animationManager = [[GDWAnimationManager   alloc]  init];
        CGRect viewFrame=self.view.frame;
        self.animationManager.presentedFrame=CGRectMake(viewFrame.size.width-200 ,( viewFrame.size.height-450)*.5, 200, 450);
    }
    return _animationManager;
}

- (IBAction)upMenuBtnClick:(UIButton *)sender {
    //加载上拉菜单控制器
    UIStoryboard *sb = [UIStoryboard  storyboardWithName:NSStringFromClass([GDWMusicUpMenuController  class]) bundle:nil];
    UIViewController * upMenuVc=[sb  instantiateInitialViewController];
    upMenuVc.transitioningDelegate=self.animationManager;
    upMenuVc.modalPresentationStyle=UIModalPresentationCustom;
    [self  presentViewController:upMenuVc animated:YES completion:nil];
    
}



@end
