//
//  SongHeaderView.h
//  music
//
//  Created by ljie on 2017/12/20.
//  Copyright © 2017年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImgview;
@property (weak, nonatomic) IBOutlet UIImageView *songImgview;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

/** 根据标签数组, 设置按钮标签 */
- (void)setupTypeLabWithTypeNames:(NSArray *)typeNames;

@end
