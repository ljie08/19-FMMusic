//
//  FYSongViewController.m
//  music
//
//  Created by 寿煜宇 on 16/5/25.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYSongViewController.h"

// 头部展示页
#import "FYHeaderView.h"
#import "SongHeaderView.h"
// 自定义Cell
#import "FYMusicDetailCell.h"
#import "TracksViewModel.h"

@interface FYSongViewController ()<UITableViewDataSource,UITableViewDelegate,FYHeaderViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) FYHeaderView  *infoView;
@property (nonatomic,strong) TracksViewModel *tracksVM;


// 升序降序标签: 默认升序
@property (nonatomic,assign) BOOL isAsc;
@end

@implementation FYSongViewController{
    CGFloat _viewY;
}

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle {
    if (self = [super init]) {
        _albumId = albumId;
        _oTitle = oTitle;
        
    }
    return self;
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    
//    self.navigationItem.title = @"专辑详情";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBackButton:YES];
    [self setupHeader];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableView懒加载
- (TracksViewModel *)tracksVM {
    if (!_tracksVM) {
        _tracksVM = [[TracksViewModel alloc] initWithAlbumId:_albumId title:_oTitle isAsc:!_isAsc];
    }
    return _tracksVM;
}

- (UITableView *)tableView {
    if (!_tableView) {
        // iOS7的状态栏（status bar）不再占用单独的20px, 所以要设置往下20px
        CGRect frame = CGRectMake(0, 0, s_WindowW, s_WindowH-64);
        //frame.origin.y += 20;
        // 设置普通模式
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        //实现了一个下拉刷新的时候顶部footer的停留
//        _tableView.contentInset = UIEdgeInsetsMake(s_WindowW*0.6, 0, 0, 0);
        
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerClass:[FYMusicDetailCell class] forCellReuseIdentifier:@"MusicDetailCell"];
        
        _tableView.rowHeight = 80;
        
    }
    return _tableView;
}

- (void)setupHeader {
    SongHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"SongHeaderView" owner:self options:nil].firstObject;
    header.frame = CGRectMake(0, 0, s_WindowW, 180);
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView = [UIView new];
    
    [self showWaiting];
    [self.tracksVM getDataCompletionHandle:^(NSError *error) {
        [self hideWaiting];
//        self.navigationItem.title = self.tracksVM.albumTitle;
        [self addNavigationWithTitle:self.tracksVM.albumTitle leftItem:nil];
        
        [self.tableView reloadData];
        // 刷新成功时候才作的方法
        
        [header.bgImgview sd_setImageWithURL:self.tracksVM.albumCoverLargeURL placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageAllowInvalidSSLCertificates];
        
        [header.songImgview sd_setImageWithURL:self.tracksVM.albumCoverURL placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageAllowInvalidSSLCertificates];
        // cover上的播放次数
        header.numLab.text = self.tracksVM.albumPlays;
         
        // 昵称及头像
        header.nameLab.text = self.tracksVM.albumNickName;
        
        [header.headerImg sd_setImageWithURL:self.tracksVM.albumIconURL];
        
        //判断?成功返回值:失败返回值
        header.detailLab.text = self.tracksVM.albumDesc.length == 0 ? @"暂无简介": self.tracksVM.albumDesc  ;
        [header setupTypeLabWithTypeNames:self.tracksVM.tagsName];
    }];
}

// 连带滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _viewY = scrollView.contentOffset.y;
}

#pragma mark - AlbumHeaderView代理方法

- (void)topLeftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topRightButtonDidClick {
    NSLog(@"右边按钮点击");
}

#pragma mark - UITableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FYMusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicDetailCell"];
    
    
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"holder"]];

    cell.titleLb.text = [self.tracksVM titleForRow:indexPath.row];
    cell.sourceLb.text = [self.tracksVM nickNameForRow:indexPath.row];
    cell.updateTimeLb.text = [self.tracksVM updateTimeForRow:indexPath.row];
    cell.playCountLb.text = [self.tracksVM playsCountForRow:indexPath.row];
    cell.durationLb.text = [self.tracksVM playTimeForRow:indexPath.row];
    cell.favorCountLb.text = [self.tracksVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text = [self.tracksVM commentCountForRow:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 点击行数  实现听歌功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前播放信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    userInfo[@"musicURL"] = [self.tracksVM playURLForRow:indexPath.row];
    //有些地址不能正确显示图片，搞不懂
    //NSLog(@"%@",[self.tracksVM coverURLForRow:indexPath.row]);
    
    //位置
    if (_viewY < -s_WindowW*0.56) {
        CGFloat origin = 190 + indexPath.row*80 - (254 + _viewY);
        NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
        userInfo[@"originy"] = originy;
    }else{
        CGFloat origin = 190 + indexPath.row*80 - (234 + _viewY);
        NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
        userInfo[@"originy"] = originy;
    }

    
    NSInteger indexPathRow = indexPath.row;
    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
    userInfo[@"indexPathRow"] = indexPathRown;
    
    //专辑
    userInfo[@"theSong"] = _tracksVM;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
}

- (void)dealloc {
    NSLog(@"song dealloc");
}

@end
