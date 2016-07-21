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
#import "XRUtils.h"
#import "Masonry.h"

@interface XRBaseTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) TableVcCellSelectedHandle handle;
@end

@implementation XRBaseTableViewController

@synthesize needCellSepLine = _needCellSepLine;
@synthesize sepLineColor = _sepLineColor;

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
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.tableView reloadData];
    
}

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

/** 需要系统分割线*/
- (void)setNeedCellSepLine:(BOOL)needCellSepLine {
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

- (void)xr_didSelectCellWithHandle:(TableVcCellSelectedHandle)handle { _handle = handle; }

- (UIView *)xr_headerAtSection:(NSInteger)section { return [XRBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (UIView *)xr_footerAtSection:(NSInteger)section { return [XRBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (CGFloat)xr_sectionHeaderHeightAtSection:(NSInteger)section { return 0.01; }

- (CGFloat)xr_sectionFooterHeaderAtSection:(NSInteger)section { return 0.01; }

- (UIEdgeInsets)xr_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath { return UIEdgeInsetsMake(0, 15, 0, 0); }

@end
