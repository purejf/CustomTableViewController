//
//  XRBaseTableViewController.m
//  Charles
//
//  Created by Charles on 16/7/16.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "XRBaseTableViewController.h"
#import "XRBaseTableViewCell.h"
#import "XRBaseTableView.h"
#import "XRBaseTableHeaderFooterView.h"
#import <objc/runtime.h>
#import "XRUtils.h"
#import "Masonry.h"

const char XRBaseTableVcNavRightItemHandleKey;
const char XRBaseTableVcNavLeftItemHandleKey;

@interface XRBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) XRTableVcCellSelectedHandle handle;
@end

@implementation XRBaseTableViewController

@synthesize needCellSepLine = _needCellSepLine;
@synthesize sepLineColor = _sepLineColor;
@synthesize navItemTitle = _navItemTitle;
@synthesize navRightItem = _navRightItem;
@synthesize hiddenStatusBar = _hiddenStatusBar;
@synthesize barStyle = _barStyle;

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

/**
 *  加载tableview
 */
- (XRBaseTableView *)tableView {
    if(!_tableView){
        XRBaseTableView *tab = [[XRBaseTableView alloc] init];
        tab.dataSource = self;
        tab.delegate = self;
        tab.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:tab];
        _tableView = tab;
        WeakSelf(weakSelf);
        [tab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.tableView reloadData];
    
}

/** 设置导航栏右边的item*/
- (void)xr_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self xr_setUpNavItemTitle:itemTitle handle:handle leftFlag:NO];
}

/** 设置导航栏左边的item*/
- (void)xr_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self xr_setUpNavItemTitle:itemTitle handle:handle leftFlag:YES];
}

- (void)xr_navItemHandle:(UIBarButtonItem *)item {
    void (^handle)(NSString *) = objc_getAssociatedObject(self, &XRBaseTableVcNavRightItemHandleKey);
    if (handle) {
        handle(item.title);
    }
}

- (void)xr_setUpNavItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag {
    if (itemTitle.length == 0 || !handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
        if (leftFlag) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    } else {
        if (leftFlag) {
            objc_setAssociatedObject(self, &XRBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(xr_navItemHandle:)];
        } else {
            objc_setAssociatedObject(self, &XRBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(xr_navItemHandle:)];
        }
    }
    
}

/** 监听通知*/
- (void)xr_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:notiName object:nil];
}

/** 设置刷新类型*/
- (void)setRefreshType:(XRBaseTableVcRefreshType)refreshType {
    _refreshType = refreshType;
    switch (self.refreshType) {
        case XRBaseTableVcRefreshTypeNone: // 没有刷新
            break ;
        case XRBaseTableVcRefreshTypeOnlyCanRefresh: { // 只有下拉刷新
            [self xr_addRefresh];
        }
            break ;
        case XRBaseTableVcRefreshTypeOnlyCanLoadMore: { // 只有上拉加载
            [self xr_addLoadMore];
        }
            break ;
        case XRBaseTableVcRefreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
            [self xr_addRefresh];
            [self xr_addLoadMore];
        }
            break ;
        default:
            break ;
    }
}

/** 导航栏标题*/
- (void)setNavItemTitle:(NSString *)navItemTitle {
    if ([navItemTitle isKindOfClass:[NSString class]] == NO) return ;
    if ([navItemTitle isEqualToString:_navItemTitle]) return ;
    _navItemTitle = navItemTitle.copy;
    self.navigationItem.title = navItemTitle;
}

- (NSString *)navItemTitle {
    return self.navigationItem.title;
}

/** statusBar是否隐藏*/
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)hiddenStatusBar {
    return _hiddenStatusBar;
}

- (void)setBarStyle:(UIStatusBarStyle)barStyle {
    if (_barStyle == barStyle) return ;
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.hiddenStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

/** 右边item*/
- (void)setNavRightItem:(UIBarButtonItem *)navRightItem {
    if ([navRightItem isKindOfClass:[UIBarButtonItem class]] == NO) {
        return ;
    }
    _navRightItem = navRightItem;
    self.navigationItem.rightBarButtonItem = navRightItem;
}

- (UIBarButtonItem *)navRightItem {
    return self.navigationItem.rightBarButtonItem;
}

/** 需要系统分割线*/
- (void)setNeedCellSepLine:(BOOL)needCellSepLine {
    if (_needCellSepLine == needCellSepLine) return ;
    _needCellSepLine = needCellSepLine;
    self.tableView.separatorStyle = needCellSepLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
}

- (BOOL)needCellSepLine {
    return self.tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine;
}

- (void)xr_addRefresh {
    [XRUtils addPullRefreshForScrollView:self.tableView pullRefreshCallBack:^{
        [self xr_refresh];
    }];
}

- (void)xr_addLoadMore {
    [XRUtils addLoadMoreForScrollView:self.tableView loadMoreCallBack:^{
        [self xr_loadMore];
    }];
}

/** 表视图偏移*/
- (void)setTableEdgeInset:(UIEdgeInsets)tableEdgeInset {
    
    BOOL edgeInsetEqual = UIEdgeInsetsEqualToEdgeInsets(self.tableEdgeInset, tableEdgeInset);
    if (edgeInsetEqual) return ;
    
    _tableEdgeInset = tableEdgeInset;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    WeakSelf(weakSelf);
    // update
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).mas_offset(weakSelf.tableEdgeInset);
    }];
}

/** 分割线颜色*/
- (void)setSepLineColor:(UIColor *)sepLineColor {
    if (!self.needCellSepLine) return;
    _sepLineColor = sepLineColor;
    
    if (sepLineColor) {
        self.tableView.separatorColor = sepLineColor;
    }
}

- (UIColor *)sepLineColor {
    return _sepLineColor ? _sepLineColor : [UIColor whiteColor];
}

/** 刷新数据*/
- (void)xr_reloadData {
    [self.tableView reloadData];
}

/** 开始下拉*/
- (void)xr_beginRefresh {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils beginPullRefreshForScrollView:self.tableView];
    }
}

/** 刷新*/
- (void)xr_refresh {
    if (self.refreshType == XRBaseTableVcRefreshTypeNone || self.refreshType == XRBaseTableVcRefreshTypeOnlyCanLoadMore) {
        return ;
    }
}

/** 上拉加载*/
- (void)xr_loadMore {
    if (self.refreshType == XRBaseTableVcRefreshTypeNone || self.refreshType == XRBaseTableVcRefreshTypeOnlyCanRefresh) {
        return ;
    }
}

/** 停止刷新*/
- (void)xr_endRefresh {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils endRefreshForScrollView:self.tableView];
    }
}

/** 停止上拉加载*/
- (void)xr_endLoadMore {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils endLoadMoreForScrollView:self.tableView];
    }
}

/** 隐藏刷新*/
- (void)xr_hiddenRrefresh {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils hiddenHeaderForScrollView:self.tableView];
    }
}

/** 隐藏上拉加载*/
- (void)xr_hiddenLoadMore {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils hiddenFooterForScrollView:self.tableView];
    }
}

/** 提示没有更多信息*/
- (void)xr_noticeNoMoreData {
    if (self.refreshType == XRBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == XRBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [XRUtils noticeNoMoreDataForScrollView:self.tableView];
    }
}

/** 头部正在刷新*/
- (BOOL)isHeaderRefreshing {
    return [XRUtils headerIsRefreshForScrollView:self.tableView];
}

/** 尾部正在刷新*/
- (BOOL)isFooterRefreshing {
    return [XRUtils footerIsLoadingForScrollView:self.tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(xr_numberOfSections)]) {
        return self.xr_numberOfSections;
    }
    return 0;
}

// 指定组返回的cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(xr_numberOfRowsInSection:)]) {
        return [self xr_numberOfRowsInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(xr_headerAtSection:)]) {
        return [self xr_headerAtSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(xr_footerAtSection:)]) {
        return [self xr_footerAtSection:section];
    }
    return nil;
}

// 每一行返回指定的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(xr_cellAtIndexPath:)]) {
        return [self xr_cellAtIndexPath:indexPath];
    }
    // 1. 创建cell
    XRBaseTableViewCell *cell = [XRBaseTableViewCell cellWithTableView:self.tableView];
    
    // 2. 返回cell
    return cell;
}

// 点击某一行 触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.handle) {
        XRBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.handle(cell, indexPath);
    }
}

// 设置分割线偏移间距并适配
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.needCellSepLine) return ;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([self respondsToSelector:@selector(xr_sepEdgeInsetsAtIndexPath:)]) {
        edgeInsets = [self xr_sepEdgeInsetsAtIndexPath:indexPath];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) [tableView setSeparatorInset:edgeInsets];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) [tableView setLayoutMargins:edgeInsets];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:edgeInsets];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) [cell setLayoutMargins:edgeInsets];
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(xr_cellheightAtIndexPath:)]) {
        return [self xr_cellheightAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(xr_sectionHeaderHeightAtSection:)]) {
        return [self xr_sectionHeaderHeightAtSection:section];
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(xr_sectionFooterHeaderAtSection:)]) {
        return [self xr_sectionFooterHeaderAtSection:section];
    }
    return 0.01;
}

- (NSInteger)xr_numberOfSections { return 0; }

- (NSInteger)xr_numberOfRowsInSection:(NSInteger)section { return 0; }

- (XRBaseTableViewCell *)xr_cellAtIndexPath:(NSIndexPath *)indexPath { return [XRBaseTableViewCell cellWithTableView:self.tableView]; }

- (CGFloat)xr_cellheightAtIndexPath:(NSIndexPath *)indexPath { return 0; }

- (void)xr_didSelectCellWithHandle:(XRTableVcCellSelectedHandle)handle { _handle = handle; }

- (UIView *)xr_headerAtSection:(NSInteger)section { return [XRBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (UIView *)xr_footerAtSection:(NSInteger)section { return [XRBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (CGFloat)xr_sectionHeaderHeightAtSection:(NSInteger)section { return 0.01; }

- (CGFloat)xr_sectionFooterHeaderAtSection:(NSInteger)section { return 0.01; }

- (UIEdgeInsets)xr_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath { return UIEdgeInsetsMake(0, 15, 0, 0); }

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
