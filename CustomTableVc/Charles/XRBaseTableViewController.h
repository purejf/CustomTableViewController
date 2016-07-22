//
//  XRBaseTableViewController.h
//  Charles
//
//  Created by Charles on 16/7/16.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRBaseTableView, XRBaseTableViewCell;

typedef void(^XRTableVcCellSelectedHandle)(XRBaseTableViewCell *cell, NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger, XRBaseTableVcRefreshType) {
    /** 无法刷新*/
    XRBaseTableVcRefreshTypeNone = 0,
    /** 只能刷新*/
    XRBaseTableVcRefreshTypeOnlyCanRefresh,
    /** 只能上拉加载*/
    XRBaseTableVcRefreshTypeOnlyCanLoadMore,
    /** 能刷新*/
    XRBaseTableVcRefreshTypeRefreshAndLoadMore
};
@class XRBaseTableViewController;

@protocol XRBaseTableViewControllerDelegate <NSObject>
- (void)baseTableViewController:(XRBaseTableViewController *)controller didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface XRBaseTableViewController : UIViewController

/** 设置导航栏右边的item*/
- (void)xr_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle;

/** 设置导航栏左边的item*/
- (void)xr_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle;

/** 监听通知*/
- (void)xr_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action;

/** 隐藏statusBar*/
@property (nonatomic, assign) BOOL hiddenStatusBar;

/** statusBar风格*/
@property (nonatomic, assign) UIStatusBarStyle barStyle;

/** 导航右边Item*/
@property (nonatomic, strong) UIBarButtonItem *navRightItem;

/** 点击某个cell的代理，子类可以继承协议继续扩充*/
@property (nonatomic, weak) id <XRBaseTableViewControllerDelegate> delegate;

/** 标题*/
@property (nonatomic, copy) NSString *navItemTitle;

/** 表视图*/
@property (nonatomic, weak) XRBaseTableView *tableView;

/** 表视图偏移*/
@property (nonatomic, assign) UIEdgeInsets tableEdgeInset;

/** 分割线颜色*/
@property (nonatomic, assign) UIColor *sepLineColor;

/** 数据源数量*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 加载刷新类型*/
@property (nonatomic, assign) XRBaseTableVcRefreshType refreshType;

/** 是否需要系统的cell的分割线*/
@property (nonatomic, assign) BOOL needCellSepLine;

/** 刷新数据*/
- (void)xr_reloadData;

/** 开始下拉*/
- (void)xr_beginRefresh;

/** 停止刷新*/
- (void)xr_endRefresh;

/** 停止上拉加载*/
- (void)xr_endLoadMore;

/** 隐藏刷新*/
- (void)xr_hiddenRrefresh;

/** 隐藏上拉加载*/
- (void)xr_hiddenLoadMore;

/** 提示没有更多信息*/
- (void)xr_noticeNoMoreData;

/** 是否在下拉刷新*/
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;

/** 是否在上拉加载*/
@property (nonatomic, assign, readonly) BOOL isFooterRefreshing;

#pragma mark - 子类去重写
/** 分组数量*/
- (NSInteger)xr_numberOfSections;

/** 某个分组的cell数量*/
- (NSInteger)xr_numberOfRowsInSection:(NSInteger)section;

/** 某行的cell*/
- (XRBaseTableViewCell *)xr_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 点击某行*/
- (void)xr_didSelectCellWithHandle:(XRTableVcCellSelectedHandle)handle;

/** 某行行高*/
- (CGFloat)xr_cellheightAtIndexPath:(NSIndexPath *)indexPath;

/** 某个组头*/
- (UIView *)xr_headerAtSection:(NSInteger)section;

/** 某个组尾*/
- (UIView *)xr_footerAtSection:(NSInteger)section;

/** 某个组头高度*/
- (CGFloat)xr_sectionHeaderHeightAtSection:(NSInteger)section;

/** 某个组尾高度*/
- (CGFloat)xr_sectionFooterHeaderAtSection:(NSInteger)section;

/** 分割线偏移*/
- (UIEdgeInsets)xr_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 子类去继承
/** 刷新方法*/
- (void)xr_refresh;

/** 上拉加载方法*/
- (void)xr_loadMore;
@end
