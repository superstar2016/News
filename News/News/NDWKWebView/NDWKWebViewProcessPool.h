//
//  NDWKWebViewProcessPool.h
//  naverdicapp
//
//  Created by naver on 2017/1/23.
//  Copyright © 2017年 Naver_China. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface NDWKWebViewProcessPool : NSObject
@property (nonatomic, strong) WKProcessPool * pool;

+ (instancetype)sharedInstance;
@end
