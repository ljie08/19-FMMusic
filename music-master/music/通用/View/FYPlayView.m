//
//  FYPlayView.m
//  music
//
//  Created by 寿煜宇 on 16/5/12.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYPlayView.h"

@implementation FYPlayView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.borderColor = MyColor.CGColor;
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 30;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.playButton setImage:[UIImage imageNamed:@"tabbar_np_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        self.tag = 100;
        [self addGestureRecognizer:tap];
        
        // 设置circle的用户交互
        self.userInteractionEnabled = YES;
        _circleIV.userInteractionEnabled = YES;
    }
    
    return self;
}

- (UIImageView *)contentIV {
    if (!_contentIV) {
        // 声明一个内容视图, 并约束好位置
        _contentIV = [[UIImageView alloc] init];
        // 绑定到圆视图
        [self addSubview:_contentIV];
        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        // KVO观察image变化, 变化了就初始化定时器, 值变化则执行task, BlockKit框架对通知的一个拓展
        [_contentIV bk_addObserverForKeyPath:@"image" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            // 启动定时器
        }];
        // 作圆内容视图背景
        _contentIV.layer.cornerRadius = 25;
        _contentIV.clipsToBounds = YES;
    }
    return _contentIV;
}

- (UIButton *)playButton {
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];// 去掉长按高亮
        _playButton.tag = 101;
        [self  addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
    }
    
    return _playButton;
}

- (void)setPlayButtonView{
    
    [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

- (void)setPauseButtonView{
    
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avatar_bg"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"toolbar_play_h_p"] forState:UIControlStateNormal];
}

-(void)touchPlayButton:(UIButton *)sender{
    
    int tag = (int)sender.tag-100;
    [self.delegate playButtonDidClick:tag];
}

-(void)OnTapBackView:(UITapGestureRecognizer *)sender//点击触发 手势
{
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-100;
    [self.delegate playButtonDidClick:tag];
}

@end
