//
//  XRUtils.m
//  Charles
//
//  Created by Charles on 16/6/20.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "XRUtils.h"
#import "MJRefresh.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  弱指针
 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@implementation XRUtils

+ (NSInteger)totalDataCountForScrollView:(UIScrollView *)scrollView {
    NSInteger totalCount = 0;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

/** 开始下拉刷新*/
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

/**判断头部是否在刷新*/
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView {
    
    BOOL flag =  scrollView.mj_header.isRefreshing;
    if (flag) {
//        NSLog(@"mj_header正在刷新");
    } else {
//        NSLog(@"mj_header停止刷新");
    }
    return flag;
}

/**判断是否尾部在刷新*/
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView {
    return  scrollView.mj_footer.isRefreshing;
}

/**提示没有更多数据的情况*/
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

/**重置footer*/
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer resetNoMoreData];
}

/**停止下拉刷新*/
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}

/**停止上拉加载*/
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}

/** 隐藏footer*/
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView {
    // 不确定是哪个类型的footer
    scrollView.mj_footer.hidden = YES;
}


/**隐藏header*/
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView {
    scrollView.mj_header.hidden = YES;
}

/**上拉*/
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(XRRefreshAndLoadMoreHandle)loadMoreCallBackBlock {
    
    if (scrollView == nil || loadMoreCallBackBlock == nil) {
        return ;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (loadMoreCallBackBlock) {
            loadMoreCallBackBlock();
        }
    }];
    
    footer.beginRefreshingCompletionBlock = ^{
    };
    footer.endRefreshingCompletionBlock = ^{
    };
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.automaticallyHidden = YES;
    scrollView.mj_footer = footer;
}

/**下拉*/
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                pullRefreshCallBack:(XRRefreshAndLoadMoreHandle)pullRefreshCallBackBlock {
    if (scrollView == nil || pullRefreshCallBackBlock == nil) {
        return ;
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
//        NSLog(@"下拉中..");
        if (pullRefreshCallBackBlock) {
            pullRefreshCallBackBlock();
        }
    }];
    
    header.beginRefreshingCompletionBlock = ^{
//        NSLog(@"开始下拉");
    };
    header.endRefreshingCompletionBlock = ^{
//        NSLog(@"下拉完成");
    };
    // 下拉的时候 footer还原
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    scrollView.mj_header = header;
}

/**返回有效的string*/
+ (NSString *)validString:(NSString *)string {
    
    if ([self isBlankString:string]) {
        return  @"";
    } else {
        return string;
    }
}

/** 判断字符串是否为空*/
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/** 获取视频某一帧的图像*/
+ (UIImage *)xr_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    if (videoURL == nil && [videoURL isKindOfClass:[NSNull class]]) return [UIImage new];
    
    if (time < 0) return [UIImage new];
    
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
    
}


@end

