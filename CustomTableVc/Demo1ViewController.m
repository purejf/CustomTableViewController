//
//  Demo1ViewController.m
//  CharlesCustomTableViewController
//
//  Created by Charles on 16/7/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "Demo1ViewController.h"
#import "XRSlideOperationViewCell.h"
#import "Masonry.h"
#import "XRSlideTestCell.h"
#import "XRUtils.h"

@interface Demo1ViewController () <XRSlideOperationViewCellDataSource, XRSlideOperationViewCellDelegate>

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // 设置刷新试试
    self.refreshType = XRBaseTableVcRefreshTypeRefreshAndLoadMore;
    
    // 设置位置
    //    self.tableEdgeInset = UIEdgeInsetsMake(40, 0, 0, 0);
    // 基类控制器和基类tableview和基类cell中还有好多东西
    [self xr_reloadData];
}

- (void)loadData {
    
    for (int i = 0 ; i < 20; i++) {
        if (i % 2 == 0) {
            [self.dataArray addObject:@(YES)];
        } else {
            [self.dataArray addObject:@(NO)];
        }
    }
}

- (void)xr_refresh {
    // 调用super方法
    [super xr_refresh];
    
    [self.dataArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1. 加载数据
        [self loadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 2. 加载数据完成
                [self xr_endRefresh];
                
                // 3.刷新界面
                [self xr_reloadData];
            });
        });
    });
    
}

- (void)xr_loadMore {
    [super xr_loadMore];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1. 加载数据
        int count = (int)self.dataArray.count;
        for (int i = count; i < count + 20; i++) {
            if (i % 2 == 0) {
                [self.dataArray addObject:@(YES)];
            } else {
                [self.dataArray addObject:@(NO)];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 2. 加载数据完成
                [self xr_endLoadMore];
                
                // 3. 刷新界面
                [self xr_reloadData];
            });
        });
    });
}

- (NSInteger)xr_numberOfSections {
    return 1;
}

- (NSInteger)xr_numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)xr_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (XRBaseTableViewCell *)xr_cellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *boolFlag = self.dataArray[indexPath.row];
    
    if (boolFlag.boolValue) {
        
        XRBaseTableViewCell *cell = [XRBaseTableViewCell cellWithTableView:self.tableView];
        cell.textLabel.text = @"这就是一个普通的cell";
        return cell;
        
    } else {
        XRSlideTestCell *cell = [XRSlideTestCell cellWithTableView:self.tableView];
        cell.name = @"这是一个可以滑动的cell，不信你左滑试试";
        cell.delegate = self;
        cell.dataSource = self;
        cell.cellContentView.backgroundColor = [UIColor lightGrayColor];
        // 加载内容加到这上面。。
        return cell;
    }
    return [[XRBaseTableViewCell alloc] init];
}

- (NSInteger)numberOfItemsInSlideOperation:(XRSlideOperationViewCell *)cell {
    return 3;
}


#pragma mark - <XRSlideOperationViewCellDataSource, XRSlideOperationViewCellDelegate>
- (UIButton *)slideOperationViewCell:(XRSlideOperationViewCell *)cell buttonAtIndex:(NSInteger)index {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:[NSString stringWithFormat:@"第%ld个", index] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIColor *bgColor = [UIColor redColor];
    if (index == 0) {
        bgColor = [UIColor redColor];
    } else if (index == 1) {
        bgColor = [UIColor greenColor];
    } else if (index == 2) {
        bgColor = [UIColor whiteColor];
    }
    [btn setBackgroundColor:bgColor];
    return btn;
}

- (void)slideOperationViewCell:(XRSlideOperationViewCell *)cell didSelectButtonAtIndex:(NSInteger)index {
    NSLog(@"%@", [NSString stringWithFormat:@"点击了第几%ld个按钮", index]);
}

- (CGSize)slideOperationViewCell:(XRSlideOperationViewCell *)cell sizeAtIndex:(NSInteger)index {
    if (index == 0) {
        return CGSizeMake(80, 100);
    } else if (index == 1) {
        return CGSizeMake(60, 100);
    } else if (index == 2) {
        return CGSizeMake(100, 100);
    }
    return CGSizeZero;
}

// 开始滑动的时候调用
- (void)slideOperationViewCellDidBeginSlide:(XRSlideOperationViewCell *)cell {
    NSLog(@"---begin---slide");
}

@end
