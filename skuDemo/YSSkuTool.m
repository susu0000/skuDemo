//
//  YSSkuTool.m
//  skuDemo
//
//  Created by Magic-Yu on 2018/4/20.
//  Copyright © 2018年 Magic-Yu. All rights reserved.
//

#import "YSSkuTool.h"



@implementation YSSkuTool

//id a = @[@{@"颜色" : @"绿色", @"款式" : @"2018款", @"尺码" : @"M", @"sku_id" : @"1"},
//         @{@"颜色" : @"红色", @"款式" : @"2016款", @"尺码" : @"M", @"sku_id" : @"2"},
//         @{@"颜色" : @"绿色", @"款式" : @"2016款", @"尺码" : @"S", @"sku_id" : @"3"},
//         @{@"颜色" : @"蓝色", @"款式" : @"2017款", @"尺码" : @"L", @"sku_id" : @"4"},
//         @{@"颜色" : @"绿色", @"款式" : @"2018款", @"尺码" : @"L", @"sku_id" : @"5"}];

// 单例
static id _instance;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
    
}

- (void)setOriginalData:(id)data{
    
    _data1 = data;
    _data2 = [self getData2];
    _data4 = [self getData4];
    _data5 = [self getData5];
    _data6 = [self getData6];
    _data7 = [self getData7];
    
    NSLog(@"%s", __func__);
    
    
}




- getData2{
    
    NSDictionary *dict = _data1[0];
    NSMutableArray *keys = [[dict allKeys] mutableCopy];
    [keys removeObject:@"sku_id"];
    return keys;
    
}

- getData4{
    
    
    NSMutableArray<NSMutableArray *> *data4 = [@[] mutableCopy];
    for (int i = 0; i < _data2.count; i++) {
        [data4 addObject:[@[] mutableCopy]];
    }
    
    
    __weak typeof(self) weak = self;
    
    [weak.data1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSInteger index = [weak.data2 indexOfObject:key];
            if (index != NSNotFound) {
                [data4[index] containsObject:obj]? : [data4[index] addObject:obj];
            }
        }];
        
    }];
    
    
    return [data4 copy];
}

- getData5{
    
    NSMutableArray<NSMutableArray *> *data5 = [@[] mutableCopy];
    for (int i = 0; i < _data4.count; i++) {
        [data5 addObject:[@[] mutableCopy]];
    }
    __block NSInteger index = 0;
    [_data4 enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
       
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            data5[idx1][idx2] = [self getPrimeWithIndex:index];
            index++;
        }];
        
    }];
    
    return [data5 copy];
}

- getData6{
    
    __weak typeof(self) weak = self;
    NSMutableArray *data6 = [@[] mutableCopy];
    [weak.data1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSInteger primeProduct = 1;
        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([weak.data2 containsObject:key]) {
                
                NSInteger index1 = [weak.data2 indexOfObject:key];
                NSInteger index2 = [weak.data4[index1] indexOfObject:obj];
                NSInteger prime  = [weak.data5[index1][index2] integerValue];
                primeProduct *= prime;
                
            }
        }];
        
        [data6 addObject:@(primeProduct)];
    }];
    
    return data6;
    
}

- getData7{
    
    NSMutableArray *data7 = [@[] mutableCopy];
    for (int i = 0; i < _data2.count; i++) {
        [data7 addObject:@1];
    }
    return data7;
}

- (NSNumber *)getPrimeWithIndex:(NSInteger)index{
    return @[@2, @3, @5, @7, @11, @13, @17, @19, @23, @29, @37, @41, @43, @47, @53, @59, @61, @67, @71, @73][index];
}


- (void)inputWithRow:(NSInteger)row column:(NSInteger)column status:(YSSkuStatus)status{

    switch (status) {
        case 0:
            _data7[row] = @1;
            break;
        case 1:
            _data7[row] = _data5[row][column];
            break;
        case 2:
            _data7 = [self getData7];
            _data7[row] = _data5[row][column];
            break;
        default:
            break;
    }

    
    
    // 刷新
    __weak typeof(self) weak = self;
    [weak.data5 enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
       
        [obj1 enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop) {
           
            if ([obj2 integerValue] == [weak.data7[idx1] integerValue]) {
                !weak.callback? : weak.callback(idx1, idx2, YSSkuStatusSelect);
            }else{
                
                __block NSInteger primeProduct = 1;
                [weak.data7 enumerateObjectsUsingBlock:^(id  _Nonnull obj3, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == idx1) {
                        primeProduct *= [obj2 integerValue];
                    }else{
                        primeProduct *= [obj3 integerValue];
                    }
                }];
                
                __block BOOL isContain = NO;
                [weak.data6 enumerateObjectsUsingBlock:^(id  _Nonnull obj4, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj4 integerValue] % primeProduct == 0) {
                        isContain = YES;
                        *stop = YES;
                    }
                }];
                
                if (isContain) {
                    !weak.callback? : weak.callback(idx1, idx2, YSSkuStatusNormal);
                }else{
                    !weak.callback? : weak.callback(idx1, idx2, YSSkuStatusDisable);
                }
                
            }
            
        }];
        
    }];
    
}

@end
