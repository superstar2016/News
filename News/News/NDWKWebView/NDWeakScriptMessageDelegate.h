//
//  NDWeakScriptMessageDelegate.h
//  IMYWebView
//
//  Created by zhaobo on 2016/09/22.
//  Copyright © 2016年 Naver. All rights reserved.
// 用代理注册调用一次，解决 直接注册 WKScriptMessageHandler 对象无法销毁的问题。

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>

@interface NDWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
