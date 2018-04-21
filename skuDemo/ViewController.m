//
//  ViewController.m
//  skuDemo
//
//  Created by Magic-Yu on 2018/4/20.
//  Copyright © 2018年 Magic-Yu. All rights reserved.
//

#import "ViewController.h"
#import "YSSkuTool.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<NSMutableArray<UIButton *> *> *btns;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.btns = @[[@[] mutableCopy],
                  [@[] mutableCopy],
                  [@[] mutableCopy]];
    
    id a = @[@{@"颜色" : @"绿色", @"款式" : @"2018款", @"尺码" : @"M", @"sku_id" : @"1"},
             @{@"颜色" : @"红色", @"款式" : @"2016款", @"尺码" : @"M", @"sku_id" : @"2"},
             @{@"颜色" : @"绿色", @"款式" : @"2016款", @"尺码" : @"S", @"sku_id" : @"3"},
             @{@"颜色" : @"蓝色", @"款式" : @"2017款", @"尺码" : @"L", @"sku_id" : @"4"},
             @{@"颜色" : @"绿色", @"款式" : @"2018款", @"尺码" : @"L", @"sku_id" : @"5"}];
    
    
    [[YSSkuTool shareInstance] setOriginalData:a];
    
    
    // 布局
    __weak typeof(self) weak = self;
    [[YSSkuTool shareInstance].data4 enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
       
        UILabel *titleLbl = [UILabel new];
        titleLbl.text = [YSSkuTool shareInstance].data2[idx1];
        titleLbl.frame = CGRectMake(10, 100 + idx1 * 100, 100, 20);
        [self.view addSubview:titleLbl];
        
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
           
            UIButton *btn = [UIButton new];
            btn.tag = 1;
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake(110 * idx2 + 10, 130 + idx1 * 100, 100, 30);
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [weak.btns[idx1] addObject:btn];
            
        }];
        
    }];
    
    [YSSkuTool shareInstance].callback = ^(NSInteger row, NSInteger column, YSSkuStatus status) {
      
        UIButton *btn = weak.btns[row][column];
        
        btn.tag = status;
        id color = @[[UIColor redColor], [UIColor blackColor], [UIColor lightGrayColor]][status];
        [btn setTitleColor:color forState:UIControlStateNormal];
        
    };
    
}

- (void)btnClick:(UIButton *)sender{
 
    __block NSInteger index1;
    __block NSInteger index2;
    
    [_btns enumerateObjectsUsingBlock:^(NSMutableArray<UIButton *> * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (obj == sender) {
                index1 = idx1;
                index2 = idx2;
            }
        }];
    }];
    
    [[YSSkuTool shareInstance] inputWithRow:index1 column:index2 status:sender.tag];
    
}



@end
