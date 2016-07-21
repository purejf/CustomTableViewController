//
//  ViewController.m
//  CharlesCustomTableViewController
//
//  Created by Charles on 16/7/21.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "ViewController.h"
#import "Demo1ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 点击一下试试
- (IBAction)btnClick:(UIButton *)sender {
    Demo1ViewController *demo1 = [[Demo1ViewController alloc] init];
    [self presentViewController:demo1 animated:YES completion:nil];
}

@end
