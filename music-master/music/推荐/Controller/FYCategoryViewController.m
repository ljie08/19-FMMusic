//
//  FYCategoryViewController.m
//  music
//
//  Created by 寿煜宇 on 16/5/25.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYCategoryViewController.h"

#import "MoreCategoryViewModel.h"
#import "FYMoreCategoryCell.h"

#import "FYSongViewController.h"

@interface FYCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MoreCategoryViewModel *categoryVM;

@end

@implementation FYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton:YES];
    
    // 启动开启上拉刷新
    [self.tableView.mj_header beginRefreshing];
//    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar = nil;
    
    [self setupNav];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

-(void)setupNav{
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationItem.title = self.keyName;
    [self addNavigationWithTitle:self.keyName leftItem:nil];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoryVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FYMoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCCell"];
    
    [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.categoryVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"holder"]];
    
    cell.titleLb.text = [self.categoryVM titleForRow:indexPath.row];
    cell.introLb.text = [self.categoryVM introForRow:indexPath.row];
    cell.playsLb.text = [self.categoryVM playsForRow:indexPath.row];
//    cell.tracksLb.text = [self.categoryVM tracksForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 从本控制器VM获取头标题, 以及分类ID回初始化
    FYSongViewController *vc = [[FYSongViewController alloc] initWithAlbumId:[self.categoryVM albumIdForRow:indexPath.row] title:[self.categoryVM titleForRow:indexPath.row]];

    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - VM,tableView懒加载
- (MoreCategoryViewModel *)categoryVM {
    if (!_categoryVM) {
        // 通过categoryID name创建网络解析
        _categoryVM = [[MoreCategoryViewModel alloc] initWithCategoryId:2 tagName:self.keyName];
    }
    return _categoryVM;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, s_WindowW, s_WindowH-64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FYMoreCategoryCell class] forCellReuseIdentifier:@"MCCell"];
        
        self.tableView.tableFooterView = [UIView new];
        // 上拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self showWaiting];
            [self.categoryVM refreshDataCompletionHandle:^(NSError *error) {
                [self hideWaiting];
                [self setFooter];
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
            }];
        }];
        
        _tableView.rowHeight = 70;
    }
    return _tableView;
}
/** 设置下拉 */
- (void)setFooter{

    if (self.categoryVM.rowNumber < 20) {

    }else{
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.categoryVM getMoreDataCompletionHandle:^(NSError *error) {
                [_tableView.mj_footer endRefreshing];
                [self changeFooter];
                [_tableView reloadData];
            }];
        }];
    }
}
/** 到底取消下拉刷新 */
- (void)changeFooter{

    if (self.categoryVM.rowNumber % 10) {
        _tableView.mj_footer = nil;
    }
}

@end
