//
//  XRBaseTableViewCell.m
//  Charles
//
//  Created by Charles on 16/6/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "XRBaseTableViewCell.h"
#import "UIView+XRNib.h"

@implementation XRBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [self nib];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

- (NSString *)nibIdentifier {
    return [[self description] stringByAppendingString:@"nibCellID"];
}

- (NSString *)identifier {
    return [[self description] stringByAppendingString:@"CellID"];
}
@end
