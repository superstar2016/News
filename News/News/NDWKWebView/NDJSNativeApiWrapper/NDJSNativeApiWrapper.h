//
//  NDJSNativeApiWrapper.h
//  naverdicapp
//
//  Created by zhu on 16/11/17.
//  Copyright © 2016年 Naver_China. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface NDJSNativeApiWrapper : NSObject

@property(strong, nonatomic)NSString *apiName;
- (id)initWithApiName : (NSString *)apiName;
-(void)addApiMethod:(NSString *)methodName withParam:(NSArray *)params;
-(BOOL)excuteWrapping:(WKUserContentController*)userContentController withMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler;

- (void)removeAllScriptMessageHandler:(WKUserContentController *)userContentController;
@end
