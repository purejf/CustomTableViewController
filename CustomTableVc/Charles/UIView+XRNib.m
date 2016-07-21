//
//  UIView+XRNib.m
//  CharlesCustomTableViewController
//
//  Created by Charles on 16/7/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "UIView+XRNib.h"

@implementation UIView (XRNib)

+ (instancetype)nib {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[self description] owner:nil options:nil];
    if (nibs.count) {
        return nibs.firstObject;
    }
    return nil;
}
@end
