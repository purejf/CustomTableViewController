//
//  XRUtils.h
//  Charles
//
//  Created by Charles on 16/6/20.
//  Copyright © 2016年 Charles. All rights reserved.
//

typedef void(^XRRefreshAndLoadMoreHandle)(void);

#import <Foundation/Foundation.h> 
#import <UIKit/UIKit.h>

/**
 *  弱指针
 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface XRUtils : NSObject

/** 开始下拉刷新 */
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断头部是否在刷新 */
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断是否尾部在刷新 */
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView;

/** 提示没有更多数据的情况 */
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**   重置footer */
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**  停止下拉刷新 */
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView;

/**  停止上拉加载 */
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView;

/**  隐藏footer */
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView;

/** 隐藏header */
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView;

/** 下拉刷新 */
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(XRRefreshAndLoadMoreHandle)loadMoreCallBackBlock;

/** 上拉加载 */
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                pullRefreshCallBack:(XRRefreshAndLoadMoreHandle)pullRefreshCallBackBlock;

/**  返回有效的字符串 将string作为参数传递的好处是 及时stirng是nil 也会有返回值@"" */
+ (NSString *)validString:(NSString *)string;

/**  判断字符串是否为空 */
+ (BOOL)isBlankString:(NSString *)string;


/** 获取视频某一帧的图像*/
+ (UIImage *)xr_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
