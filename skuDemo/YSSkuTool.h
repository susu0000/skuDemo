//
//  YSSkuTool.h
//  skuDemo
//
//  Created by Magic-Yu on 2018/4/20.
//  Copyright © 2018年 Magic-Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YSSkuStatus) {
    YSSkuStatusSelect,
    YSSkuStatusNormal,
    YSSkuStatusDisable,
};

@interface YSSkuTool : NSObject

// 单例
+ (instancetype)shareInstance;

+ (instancetype)new  __attribute__((unavailable("Disabled. Use +sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("Disabled. Use +sharedInstance instead")));
- (instancetype)copy __attribute__((unavailable("Disabled. Use +sharedInstance instead")));


// 初始数据设置
- (void)setOriginalData:(id)data;

// 输入
- (void)inputWithRow:(NSInteger)row column:(NSInteger)column status:(YSSkuStatus)status;

// 输出
@property (nonatomic, copy) void(^callback)(NSInteger row, NSInteger column, YSSkuStatus status);


@property (nonatomic, copy) NSArray *data1;
@property (nonatomic, copy) NSArray *data2;
@property (nonatomic, copy) NSArray *data4;
@property (nonatomic, copy) NSArray *data5;
@property (nonatomic, copy) NSArray *data6;
@property (nonatomic, strong) NSMutableArray *data7;

@end
