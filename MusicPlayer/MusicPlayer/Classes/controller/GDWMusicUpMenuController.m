//
//  GDWMusicUpMenuController.m
//  MusicPlayer
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWMusicUpMenuController.h"

#import "GDWMusicTool.h"
#import "GDWMusicModel.h"
#import "GDWMusicCell.h"

@interface GDWMusicUpMenuController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
/** 音乐 */
@property (nonatomic, strong) NSArray *musics;
@end

@implementation GDWMusicUpMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.musicTableView.backgroundColor=GDWBackgroundColor;
    self.musicTableView.dataSource=self;
    self.musicTableView.delegate=self;
    //设置分割线
    self.musicTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.musicTableView.rowHeight=60;
    //注册cell
    [self.musicTableView  registerNib:[UINib  nibWithNibName:NSStringFromClass([GDWMusicCell  class]) bundle:nil] forCellReuseIdentifier:@"musicCell"];
    
}
/** musics懒加载 */
- (NSArray *)musics{
    if (!_musics) {
        self.musics = [GDWMusicTool  musics];
    }
    return _musics;
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.musics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    GDWMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell" ];
    
    
    GDWMusicModel *music=self.musics[indexPath.row];
    cell.music=music;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.更改正在播放歌曲
    GDWMusicModel *music=self.musics[indexPath.row];
    //[GDWMusicTool  setPlayingMusic:music];
    //2.发送通知
    [[NSNotificationCenter   defaultCenter]  postNotificationName:GDWSeletedMusicNotification object:nil userInfo:@{@"seletedMusic":music}];
    
}


@end
