//
//  UIView+XRTap.h
//  CharlesCustomTableViewController
//
//  Created by Charles on 16/7/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XRTap)

/**
 *  动态添加手势
 */
- (void)setTapActionWithBlock:(void (^)(void))block ;
@end
