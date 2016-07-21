//
//  XRBaseTableView.h
//  
//
//  Created by Charles on 16/6/20.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XRBaseTableViewRowAnimation) {
    Fade = UITableViewRowAnimationFade,
    Right = UITableViewRowAnimationRight,           // slide in from right (or out to right)
    Left = UITableViewRowAnimationLeft,
    Top = UITableViewRowAnimationTop,
    Bottom = UITableViewRowAnimationBottom,
    None = UITableViewRowAnimationNone,            // available in iOS 3.0
    Middle = UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    Automatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};
@class XRBaseTableViewCell;

@interface XRBaseTableView : UITableView

- (void)xr_updateWithUpdateBlock:(void(^)(XRBaseTableView *tableView ))updateBlock;

- (UITableViewCell *)xr_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 注册普通的UITableViewCell*/
- (void)xr_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewCell*/
- (void)xr_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)xr_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)xr_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;

#pragma mark - 只对已经存在的cell进行刷新，没有类似于系统的 如果行不存在，默认insert操作
/** 刷新单行、动画默认*/
- (void)xr_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新单行、动画默认*/
- (void)xr_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(XRBaseTableViewRowAnimation)animation;

/** 刷新多行、动画默认*/
- (void)xr_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 刷新多行、动画默认*/
- (void)xr_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(XRBaseTableViewRowAnimation)animation;

/** 刷新某个section、动画默认*/
- (void)xr_reloadSingleSection:(NSInteger)section;

/** 刷新某个section、动画自定义*/
- (void)xr_reloadSingleSection:(NSInteger)section animation:(XRBaseTableViewRowAnimation)animation;

/** 刷新多个section、动画默认*/
- (void)xr_reloadSections:(NSArray <NSNumber *>*)sections;

/** 刷新多个section、动画自定义*/
- (void)xr_reloadSections:(NSArray <NSNumber *>*)sections animation:(XRBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)xr_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除单行、动画自定义*/
- (void)xr_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(XRBaseTableViewRowAnimation)animation;

/** 删除多行、动画默认*/
- (void)xr_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 删除多行、动画自定义*/
- (void)xr_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(XRBaseTableViewRowAnimation)animation;

/** 删除某个section、动画默认*/
- (void)xr_deleteSingleSection:(NSInteger)section;

/** 删除某个section、动画自定义*/
- (void)xr_deleteSingleSection:(NSInteger)section animation:(XRBaseTableViewRowAnimation)animation;

/** 删除多个section*/
- (void)xr_deleteSections:(NSArray <NSNumber *>*)sections;

/** 删除多个section*/
- (void)xr_deleteSections:(NSArray <NSNumber *>*)sections animation:(XRBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 增加单行 动画无*/
- (void)xr_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 增加单行，动画自定义*/
- (void)xr_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(XRBaseTableViewRowAnimation)animation;

/** 增加单section，动画无*/
- (void)xr_insertSingleSection:(NSInteger)section;

/** 增加单section，动画自定义*/
- (void)xr_insertSingleSection:(NSInteger)section animation:(XRBaseTableViewRowAnimation)animation;

/** 增加多行，动画无*/
- (void)xr_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 增加多行，动画自定义*/
- (void)xr_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(XRBaseTableViewRowAnimation)animation;

/** 增加多section，动画无*/
- (void)xr_insertSections:(NSArray <NSNumber *>*)sections;

/** 增加多section，动画自定义*/
- (void)xr_insertSections:(NSArray <NSNumber *>*)sections animation:(XRBaseTableViewRowAnimation)animation;
@end
