
//
//  GDWLrcView.m
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWLrcView.h"
#import "Masonry.h"

#import "GDWLrcTool.h"
#import "GDWLrcLineModel.h"
#import "GDWLrcCell.h"
#import "GDWLrcLabe.h"
#import "GDWMusicTool.h"
#import "GDWMusicModel.h"

@interface GDWLrcView ()<UITableViewDataSource>

/* 展示歌词tableView */
@property (nonatomic,weak) UITableView *tableView;
/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcLines;

/** 记录当前歌词行数 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation GDWLrcView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self   setUpTableView];
    }
    return self;
}

- (void)awakeFromNib{
   //GDWLog
    //1.设置tableView的属性
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    
    self.tableView.backgroundColor=[UIColor  clearColor];
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //2.添加手势
    [self  setUpGesture];
    
}
- (void)layoutSubviews{
    [super   layoutSubviews];
    
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
}
#pragma mark - 设置tableView
- (void)setUpTableView{
    UITableView  *tableView=[[UITableView  alloc]  init];
    self.tableView=tableView;
    [self  addSubview:tableView];
    tableView.dataSource=self;
    
    //给tableView注册cell
    [tableView  registerNib:[UINib  nibWithNibName:NSStringFromClass([GDWLrcCell  class]) bundle:nil] forCellReuseIdentifier:@"lrcCell"];
    tableView.rowHeight=30;

}
#pragma mark - 添加手势
- (void)setUpGesture{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(tapGestureClick:)];
    [self  addGestureRecognizer:tapGesture];

}
#pragma mark 手势监听
- (void)tapGestureClick:(UIGestureRecognizer *)gesture{
    
    //取出偏移量,判断每次都会改变偏移量
    if (self.contentOffset.x>0) {
        
        [self  setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
       [self  setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:YES];
    }
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lrcLines.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GDWLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell" ];
    
    if (indexPath.row == self.currentIndex) {
        [cell  changeTextFont:[UIFont systemFontOfSize:18.0]];
    } else {
        [cell  changeTextFont:[UIFont systemFontOfSize:14.0]];
        cell.progress = 0;
    }
    
    
    GDWLrcLineModel *lrcLine=self.lrcLines[indexPath.row];
    cell.lrcLine=lrcLine;
    
    return cell;
}


#pragma mark - 重写setter方法
- (void)setLrcName:(NSString *)lrcName{
    _lrcName=[lrcName   copy];
    //歌词数组
    self.lrcLines=[GDWLrcTool   lrcWithLrcName:lrcName];
    //刷新
    [self.tableView  reloadData];
    
    //设置tableView的偏移量
    [self.tableView   setContentOffset:CGPointMake(0,-self.tableView.frame.size.height*.5) animated:YES];
}
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime=currentTime;
    for (NSInteger i=0; i<self.lrcLines.count; i++) {
        
        GDWLrcLineModel *lrcLine=self.lrcLines[i];
        // 取出下一句歌词
        NSInteger nextIndex=i+1;
        if (nextIndex >self.lrcLines.count-1)  break;
        GDWLrcLineModel *nextLrcLine=self.lrcLines[nextIndex];
        
        if (currentTime>=lrcLine.time&&currentTime<nextLrcLine.time&&self.currentTime!=i) {//找到正在播放的那句歌词
            NSIndexPath *indexPath=[NSIndexPath  indexPathForRow:i inSection:0];
            // 3.2.取出前一个位置的indexPath
            NSArray *indexPaths = nil;
            if (self.currentIndex < i) {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                indexPaths = @[indexPath, previousIndexPath];
            } else {
                indexPaths = @[indexPath];
            }
            //记录i 的下标值
            self.currentIndex=i;
            
            //刷新i位置的cell
            [self.tableView  reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            //使i对应的cell滚到中间
            [self.tableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            // 3.7.重新生成锁屏图片
            [self drawLockImage];
            
        }
        //使歌词渐变颜色
        if (self.currentIndex==i) {
            //取出对应的cell
            NSIndexPath *indexPath=[NSIndexPath   indexPathForRow:i inSection:0];
            GDWLrcCell *cell = [self.tableView   cellForRowAtIndexPath:indexPath];
            //计算进度
            CGFloat  progress = (currentTime- lrcLine.time)/(nextLrcLine.time-lrcLine.time);
            cell.progress=progress;
            
            //设置单句歌词
            self.singleLrcLable.text=lrcLine.text;
            self.singleLrcLable.progress=progress;
            
        }
        
    }
    
}

#pragma mark - 绘制锁屏界面的图片
- (void)drawLockImage
{
    // 1.取出三句歌词
    // 1.1.取出当前句的歌词
    GDWLrcLineModel *currentLrcLine = self.lrcLines[self.currentIndex];
    
    // 1.2.取出上一句歌词
    NSInteger previousLrcIndex = self.currentIndex - 1;
    GDWLrcLineModel *previousLrcLine = nil;
    if (previousLrcIndex > 0) {
        previousLrcLine = self.lrcLines[previousLrcIndex];
    }
    
    // 1.3.取出下一句歌词
    NSInteger nextLrcIndex = self.currentIndex + 1;
    GDWLrcLineModel *nextLrcLine = nil;
    if (nextLrcIndex < self.lrcLines.count) {
        nextLrcLine = self.lrcLines[nextLrcIndex];
    }
    
    // 2.取出当前歌曲的icon对应的UIImage对象
    GDWMusicModel *playingMusic = [GDWMusicTool playingMusic];
    UIImage *playingImage = [UIImage imageNamed:playingMusic.icon];
    
    // 3.开始绘制
    // 3.1.开启上下文
    UIGraphicsBeginImageContextWithOptions(playingImage.size, YES, 0);
    
    // 3.2.将图片绘制到上下文中
    [playingImage drawInRect:CGRectMake(0, 0, playingImage.size.width, playingImage.size.height)];
    
    // 3.3.将三句歌词绘制到上下文中
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributes setObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    
    // 3.3.1.定义一些常量
    CGFloat width = playingImage.size.width;
    CGFloat height = playingImage.size.height;
    CGFloat textHeight = 25;
    
    // 3.3.2.绘制当前句歌词
    CGRect currentRect = CGRectMake(0, height - 2 * textHeight, width, textHeight);
    [currentLrcLine.text drawInRect:currentRect withAttributes:attributes];
    
    // 3.3.3.绘制上一句和下一句歌词
    CGRect previousRect = CGRectMake(0, height - 3 * textHeight, width, textHeight);
    [previousLrcLine.text drawInRect:previousRect withAttributes:attributes];
    CGRect nextRect = CGRectMake(0, height - textHeight, width, textHeight);
    [nextLrcLine.text drawInRect:nextRect withAttributes:attributes];
    
    // 4.生成新的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 6.通知代理
    if ([self.lrcViewDelegate respondsToSelector:@selector(lrcView:lockScreenImage:)]) {
        [self.lrcViewDelegate lrcView:self lockScreenImage:lockImage];
    }
}


@end



