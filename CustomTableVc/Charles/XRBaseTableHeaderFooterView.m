//
//  XRBaseTableHeaderFooterView.m
//  Charles
//
//  Created by Charles on 16/7/6.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "XRBaseTableHeaderFooterView.h"
#import "UIView+XRNib.h"

@implementation XRBaseTableHeaderFooterView

+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifer = [classname stringByAppendingString:@"HeaderFooterID"];
    [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:identifer];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifer];
}

+ (instancetype)nibHeaderFooterViewWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [self nib];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifer = [classname stringByAppendingString:@"nibHeaderFooterID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifer];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifer];
}

+ (NSString *)identifier {
    return [[self description] stringByAppendingString:@"HeaderFooterID"];
}

+ (NSString *)nibIdentifier {
    return [[self description] stringByAppendingString:@"nibHeaderFooterID"];
}
@end
