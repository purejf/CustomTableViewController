//
//  XRBaseTableViewCell.h
//  Charles
//
//  Created by Charles on 16/6/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRBaseTableView.h"

@interface XRBaseTableViewCell : UITableViewCell
/**
 *  快速创建一个不是从xib中加载的tableview cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  快速创建一个从xib中加载的tableview cell
 */
+ (instancetype)nibCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *nibIdentifier;

@end
