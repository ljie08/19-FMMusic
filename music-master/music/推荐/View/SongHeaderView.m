//
//  SongHeaderView.m
//  music
//
//  Created by ljie on 2017/12/20.
//  Copyright © 2017年 Fyus. All rights reserved.
//

#import "SongHeaderView.h"

@implementation SongHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/* 根据标签数组, 设置按钮标签 */
- (void)setupTypeLabWithTypeNames:(NSArray *)typeNames {
    NSString *type = [NSString string];
    
    for (int i = 0; i < typeNames.count; i++) {
        if (i < typeNames.count - 1) {
            type = [type stringByAppendingString:[NSString stringWithFormat:@"%@ | ", typeNames[i]]];
        } else {
            type = [type stringByAppendingString:[NSString stringWithFormat:@"%@", typeNames[i]]];
        }
        self.typeLab.text = type;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.masksToBounds
//    self.layer.cornerRadius
}

@end
