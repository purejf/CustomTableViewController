//
//  XRBaseTableHeaderFooterView.h
//  Charles
//
//  Created by Charles on 16/7/6.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRBaseTableHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView;

+ (instancetype)nibHeaderFooterViewWithTableView:(UITableView *)tableView;

+ (NSString *)identifier;

+ (NSString *)nibIdentifier; 
@end
