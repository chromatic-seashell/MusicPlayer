//
//  GDWLrcCell.m
//  MusicPlayer
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWLrcCell.h"
#import "GDWLrcLabe.h"
#import "GDWLrcLineModel.h"

@interface GDWLrcCell ()

@property (weak, nonatomic) IBOutlet GDWLrcLabe *lrcLable;

@end

@implementation GDWLrcCell


+ (instancetype)lrcCellFromNib{

    return [[NSBundle  mainBundle]  loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil].firstObject;
}


- (void)awakeFromNib {
    //设置属性
    self.lrcLable.textColor=[UIColor  whiteColor];
    self.lrcLable.font=[UIFont   systemFontOfSize:14];
    //背景颜色
    self.backgroundColor=[UIColor  clearColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLrcLine:(GDWLrcLineModel *)lrcLine{
    _lrcLine=lrcLine;
    self.lrcLable.text=lrcLine.text;

}

- (void)setProgress:(CGFloat)progress{
    _progress=progress;
    //设置歌词lable的进度
    self.lrcLable.progress=progress;

}
#pragma mark - 改变字体大小
-(void)changeTextFont:(UIFont *)font{
    self.lrcLable.font=font;
}

@end
