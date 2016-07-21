//
//  XRSlideOperationViewCell.h
//  Charles
//
//  Created by Charles on 16/7/15.
//  Copyright © 2016年 Charles. All rights reserved.
//  滑动cell 执行某些操作

#import "XRBaseTableViewCell.h"

@class XRSlideOperationViewCell;
@protocol XRSlideOperationViewCellDataSource <NSObject>

/** 几个按钮*/
- (NSInteger)numberOfItemsInSlideOperation:(XRSlideOperationViewCell *)cell;
/** 按钮*/
- (UIButton *)slideOperationViewCell:(XRSlideOperationViewCell *)cell buttonAtIndex:(NSInteger)index;
/** 按钮大小*/
- (CGSize)slideOperationViewCell:(XRSlideOperationViewCell *)cell sizeAtIndex:(NSInteger)index;

@end

@protocol XRSlideOperationViewCellDelegate <NSObject>

/** 点击事件*/
- (void)slideOperationViewCell:(XRSlideOperationViewCell *)cell didSelectButtonAtIndex:(NSInteger)index;
/** 开始滑动的时候*/
- (void)slideOperationViewCellDidBeginSlide:(XRSlideOperationViewCell *)cell;

@end

@interface XRSlideOperationViewCell : XRBaseTableViewCell

@property (nonatomic, weak) id <XRSlideOperationViewCellDataSource> dataSource;
@property (nonatomic, weak) id <XRSlideOperationViewCellDelegate> delegate;
/** 容器视图 类似于contentView*/
@property (nonatomic, weak) UIView *cellContentView; 
@end
