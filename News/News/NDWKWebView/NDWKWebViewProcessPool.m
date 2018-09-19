//
//  NDWKWebViewProcessPool.m
//  naverdicapp
//
//  Created by naver on 2017/1/23.
//  Copyright © 2017年 Naver_China. All rights reserved.
//

#import "NDWKWebViewProcessPool.h"
static id _sharedInstance;
@implementation NDWKWebViewProcessPool
static NDWKWebViewProcessPool *_sharedInstance = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (WKProcessPool *)pool{
    if (!_pool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _pool = [[WKProcessPool alloc] init];
        });
    }
    return _pool;
}
@end
