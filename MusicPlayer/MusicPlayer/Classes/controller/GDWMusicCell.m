//
//  GDWMusicCell.m
//  MusicPlayer
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GDWMusicCell.h"
#import "GDWMusicModel.h"

@interface GDWMusicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *singerName;

@end


@implementation GDWMusicCell

- (void)awakeFromNib {
    self.backgroundColor=GDWBackgroundColor;
    
    UIView *seleteView=[[UIView  alloc]  initWithFrame:self.bounds];
    seleteView.backgroundColor=GDWBackgroundColor;
    self.selectedBackgroundView=seleteView;
    
    self.name.textColor=[UIColor   whiteColor];
    self.singerName.textColor=[UIColor   whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //这个方法会调用很多次.
    if (selected) {
       //设置cell属性
        self.name.textColor=[UIColor   greenColor];
        self.singerName.textColor=[UIColor   greenColor];
        self.singerIcon.image=[UIImage   imageCircleClippingWithImage:[UIImage imageNamed:self.music.singerIcon] border:1 scale:1 color:[UIColor greenColor] baseDistance:50];
    }else{
        self.name.textColor=[UIColor   whiteColor];
        self.singerName.textColor=[UIColor   whiteColor];
        self.singerIcon.image=[UIImage   imageCircleClippingWithImage:[UIImage imageNamed:self.music.singerIcon] border:1 scale:1 color:[UIColor whiteColor] baseDistance:50];
    }
}

#pragma mark - setter
-(void)setMusic:(GDWMusicModel *)music{
    _music=music;
    
    self.name.text=music.name;
    self.singerName.text=music.singer;
    //self.singerIcon.image=[UIImage imageNamed:music.singerIcon];
    self.singerIcon.image=[UIImage   imageCircleClippingWithImage:[UIImage imageNamed:music.singerIcon] border:1 scale:1 color:[UIColor whiteColor] baseDistance:50];
}

@end
