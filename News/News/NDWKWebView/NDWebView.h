//
//  NDWebView.h
//  ND_ViewKit
//
//  Created by zhabo on 2016/09/21.
//  Copyright (c) 2016年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
typedef enum _DeleteWebHistory{
    DeleteWebHistoryUrlHistory = 0,//api不支持
    DeleteWebHistoryCookie,
    DeleteWebHistoryCaches
}DeleteWebHistory;
@class NDWebView;
@protocol NDWebViewDelegate <NSObject>
@optional
//以uiwebView&WKWebView 以UIWebView Delegate的方式回调
//开始加载
- (void)webViewDidStartLoad:(NDWebView *)webView;

//加载完毕
- (void)webViewDidFinishLoad:(NDWebView *)webView;

//加载失败
- (void)webView:(NDWebView *)webView didFailLoadWithError:(NSError *)error;

//开始加载之前调用 是否允许加载
- (BOOL)webView:(NDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

//用于ios8 wkWebView 设置前进和后退
- (void)webViewIsLoadingEvent:(NDWebView *)webView;

//加载页面失败，超时/服务器错误/无网络
- (void)webViewFailedLoadingUrlAfterClickAlertViewCancel:(NDWebView *)webView;

@end

///无缝切换UIWebView&WKWebView   会根据系统版本自动选择 使用WKWebView 还是  UIWebView
@interface NDWebView : UIView

///使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

//设置NDWebView 代理
@property(weak,nonatomic)id<NDWebViewDelegate> delegate;

///内部使用的webView
@property (nonatomic, readonly, strong) id realWebView;

///是否正在使用 UIWebView
@property (nonatomic, readonly, assign) BOOL usingUIWebView;

///预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

//原始请求
@property (nonatomic, readonly, strong) NSURLRequest *originRequest;

///---- UI 或者 WK 的API
@property (nonatomic, readonly, strong) UIScrollView *scrollView;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, strong) NSURLRequest *currentRequest;
@property (nonatomic, readonly, strong) NSURL *URL;

@property (nonatomic, readonly, getter=isLoading, assign) BOOL loading;
@property (nonatomic, readonly, assign) BOOL canGoBack;
@property (nonatomic, readonly, assign) BOOL canGoForward;
@property (nonatomic, assign) BOOL WKWebViewAllowsBackForwardNavigationGestures;

///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

@property (nonatomic,assign) BOOL mediaPlaybackRequiresUserAction;

@property (nonatomic, assign) BOOL hideLoadRequestErrorAlert;
///back 层数
- (NSInteger)countOfHistory;

//返回到历史第几步
- (void)gobackWithStep:(NSInteger)step;

//加载请求
- (id)loadRequest:(NSURLRequest *)request;

//加载htmlString
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;

//WKWebView 执行js的方式
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
//执行js 内部会判断
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");
;

/**
 *  添加js回调oc通知方式，适用于 iOS8 之后 的 WKWebView
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

/**
 *  注销 注册过的js回调oc通知方式，适用于 iOS8 之后
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;


/**
 *  注入document cookies(设置登录状态)
 */
- (void)setDocumnetCookie;

/**
 *  注入document cookies(设置登录状态)和DeviceID
 */
- (void)setDocumnetCookieAndDeviceId;

/**
 *  退出登录后从cookieStorage中清除登录的cookie
 */
+ (void)deleteLoginOutCookieFromCookieStorage;

/**
 增加删除wkWebView cache&&cookie 方法 适用于ios9 以上系统

 @param deleteWebHistory 类型
 @param finishedCallBack 删除成功回调
 */
+ (void)deleteWebHistoryWithCookie_webBrowseHistory_cache:(DeleteWebHistory)deleteWebHistory withFiniedCallBack:(void (^)(bool finished))finishedCallBack;
@end
