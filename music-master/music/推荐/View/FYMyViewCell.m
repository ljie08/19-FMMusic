//
//  FYMyViewCell.m
//  music
//
//  Created by 寿煜宇 on 16/6/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMyViewCell.h"

@interface FYMyViewCell()

@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;

@end

@implementation FYMyViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

-(void)setAct:(NSDictionary *)act{
    
    _act = act;
    self.coverIV.image = [UIImage imageNamed:_act[@"image"]];
    self.titleLb.text = _act[@"title"];
}

- (UIImageView *)coverIV {
    
    if(_coverIV == nil) {
        _coverIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
        }];

    }
    return _coverIV;
}

- (UILabel *)titleLb {
    
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
//        CGFloat x = CGRectGetMaxX(self.coverIV.frame)+20;
//        _titleLb.frame = CGRectMake(x, 0, 150, 80);
        _titleLb.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(self.coverIV.mas_right).mas_equalTo(20);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

@end
