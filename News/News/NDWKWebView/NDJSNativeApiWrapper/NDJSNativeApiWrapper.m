//
//  NDJSNativeApiWrapper.m
//  naverdicapp
//
//  Created by zhu on 16/11/17.
//  Copyright © 2016年 Naver_China. All rights reserved.
//

#import "NDJSNativeApiWrapper.h"

@interface NDJSNativeApiWrapper()

@property(strong, nonatomic)NSMutableDictionary *methodWithParams;

@end

@implementation NDJSNativeApiWrapper

- (id)initWithApiName : (NSString *)apiName {
    self = [super init];
    if (self) {
        self.apiName = apiName;
        self.methodWithParams = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addApiMethod:(NSString *)methodName withParam:(NSArray *)params {
    if (!params) {
        params = [[NSArray alloc] init];
    }
    [self.methodWithParams setValue:params forKey:methodName];
}

- (NSString *)obtainWrappedApiJSString {
    NSMutableString* wrappedJSStrContent = [[NSMutableString alloc] init];
    
    NSArray *methodKeys = [self.methodWithParams allKeys];
    NSInteger keysCount = methodKeys.count;
    
    for (int i=0; i<keysCount; i++) {
        NSString *methodKey = methodKeys[i];
        NSMutableString *funcParam = [NSMutableString stringWithString:@""];
        NSMutableString *messageParam = [NSMutableString stringWithString:@""];
        
        NSArray *params = self.methodWithParams[methodKey];
        
        NSInteger paramCount = params.count;
        for (int j=0; j<paramCount; j++) {
            NSString *parmValue = params[j];
            [funcParam appendString:parmValue];
            [messageParam appendString:[NSString stringWithFormat:@"\"%@\":%@", parmValue, parmValue]];
            if (j < paramCount - 1) {
                [funcParam appendString:@", "];
                [messageParam appendString:@", "];
            }
        }
    
        NSString *methodContent = [NSString stringWithFormat:@"%@ : function(%@) {window.webkit.messageHandlers.%@_%@.postMessage(%@)}", methodKey, funcParam, self.apiName, methodKey, [NSString stringWithFormat:@"{%@}", messageParam]];
        
        [wrappedJSStrContent appendString:methodContent];
        
        if (i < keysCount-1) {
            [wrappedJSStrContent appendString:@", "];
        }
    }
    
    NSString *wrappedJSStr = [NSString stringWithFormat:@"window.%@ = {%@};", self.apiName, wrappedJSStrContent];
    
    return wrappedJSStr;
}

- (BOOL)excuteWrapping:(WKUserContentController*)userContentController withMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler{
    
    if (!self.apiName || self.methodWithParams.allKeys.count < 1) {
        return NO;
    }
    
    NSArray *methodKeys = [self.methodWithParams allKeys];
    NSInteger keysCount = methodKeys.count;
    for (int i=0; i<keysCount; i++) {
        NSString *methodName = [NSString stringWithFormat:@"%@_%@", self.apiName, methodKeys[i]];
        [userContentController addScriptMessageHandler:scriptMessageHandler name:methodName];
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:[self obtainWrappedApiJSString] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [userContentController addUserScript:script];
    
    return YES;
}
- (void)removeAllScriptMessageHandler:(WKUserContentController *)userContentController{
    if (!self.apiName || self.methodWithParams.allKeys.count < 1) {
        return ;
    }
    
    NSArray *methodKeys = [self.methodWithParams allKeys];
    NSInteger keysCount = methodKeys.count;
    for (int i=0; i<keysCount; i++) {
        NSString *methodName = [NSString stringWithFormat:@"%@_%@", self.apiName, methodKeys[i]];
        [userContentController removeScriptMessageHandlerForName:methodName];
    }

}
@end
