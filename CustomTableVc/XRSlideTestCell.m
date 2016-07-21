//
//  XRSlideTestCell.m
//  CharlesCustomTableViewController
//
//  Created by Charles on 16/7/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "XRSlideTestCell.h"

@interface XRSlideTestCell ()
@property (nonatomic, weak) UILabel *nameL;


@end

@implementation XRSlideTestCell

- (UILabel *)nameL {
    if (!_nameL) {
        UILabel *label = [[UILabel alloc] init];
        [self.cellContentView addSubview:label];
        _nameL = label;
    }
    return _nameL;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameL.frame = self.cellContentView.bounds;
}

- (void)setName:(NSString *)name {
    if (name == nil || [name isKindOfClass:[NSNull class]]) {
        return ;
    }
    _name = name.copy;
    self.nameL.text = name;
}

@end
