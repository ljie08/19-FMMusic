//
//  BaseViewController.h
//  music
//
//  Created by ljie on 2017/12/19.
//  Copyright © 2017年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"//加载指示器

@interface BaseViewController : UIViewController

/**
 *  是否显示返回按钮
 *
 *  isShown
 */
- (void)setBackButton:(BOOL)isShown;

/**
 *  创建UI
 */
- (void)initUIView;

/**
 自定义标题字体、颜色、大小等
 
 @param title 标题
 */
- (void)initTitleViewWithTitle:(NSString *)title;

#pragma mark - 设置背景图
- (void)setThemeImgWithPicture:(NSString *)name;

/**
 *  绑定viewModel
 */
- (void)initViewModelBinding;

/**
 设置导航栏
 
 @param title 标题
 @param left 左item
 @param isShow 右item是否显示
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left;

/**
 *  返回，默认情况下为navigationController的弹出
 */
- (void)goBack;

//返回到根视图控制器
- (void)goRootBack;

- (MBProgressHUD *)showWaiting;//网络请求等待提示
- (void)hideWaiting;//停止等待提示
- (void)showMassage:(NSString *)massage;//提示消息


- (MBProgressHUD *)showWaitingWithMessage:(NSString *)message;//网络请求等待提示

@end
