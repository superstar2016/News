//
//  NDWebView.m
//  ND_ViewKit
//
//  Created by zhaobo on 2016/9/20.
//  Copyright (c) 2016年 ND. All rights reserved.
//
/**
 * 前端需要用 window.webkit.messageHandlers.注册的方法名.postMessage({body:传输的数据} 来给native发送消息
 * window.webkit.messageHandlers.sayhello.postMessage({body: 'hello world!'});
 * addScriptMessageHandler要和removeScriptMessageHandlerForName配套出现，否则会造成内存泄漏。
 * h5只能传一个参数，如果需要多个参数就需要用字典或者json组装。
 */
#import "NDWebView.h"

#import "NDWebViewProgress.h"
#import <TargetConditionals.h>
#import <dlfcn.h>
#import "NDAppDefine.h"
#import "NDCommonHelp.h"
#import "NDWKWebViewProcessPool.h"
#import <NaverLogin/NLoginConnection.h>
#import "NDAlertHelper.h"
#import "NDCustomAlertView.h"
#import <PureLayout/PureLayout.h>
#define kTimeoutInterval 12.0f
@interface NDWebView()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,NDWebViewProgressDelegate>

@property (nonatomic, assign) double estimatedProgress;
@property (nonatomic, strong) NSURLRequest *originRequest;
@property (nonatomic, strong) NSURLRequest *currentRequest;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NDWebViewProgress* njkWebViewProgress;
@property (nonatomic, strong) NDCustomAlertView *alertView;
@end

@implementation NDWebView

@synthesize usingUIWebView = _usingUIWebView;
@synthesize realWebView = _realWebView;
@synthesize scalesPageToFit = _scalesPageToFit;
- (NSString *)title{
    if (self.realWebView && [self.realWebView isKindOfClass:[WKWebView class]]) {
       return  ((WKWebView *)self.realWebView).title;
    }
    return nil;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initMyself];
    }
    return self;
}
- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame usingUIWebView:NO];
}
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _usingUIWebView = usingUIWebView;
        [self _initMyself];
        //self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)_initMyself
{
    Class wkWebView = NSClassFromString(@"WKWebView");
    if(wkWebView && self.usingUIWebView == NO)
    {
        [self initWKWebView];
        _usingUIWebView = NO;
    }
    else
    {
        [self initUIWebView];
        _usingUIWebView = YES;
    }
    self.scalesPageToFit = YES;
    
//    [self.realWebView setFrame:self.bounds];
//    [self.realWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.realWebView];
    [self.realWebView autoPinEdgesToSuperviewEdges];
}
-(void)initWKWebView
{
    WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    WKPreferences *preference = [NSClassFromString(@"WKPreferences") new];
    configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];
    configuration.processPool = [NDWKWebViewProcessPool sharedInstance].pool; //解决存在多个WkWebView cookie共享问题
    // 允许在线播放
    configuration.allowsInlineMediaPlayback = YES;
    preference.javaScriptCanOpenWindowsAutomatically = YES;//允许js打开新窗口
    configuration.preferences = preference;
    // 在wkWebView初始化之前 设置播放视频时是否需要用户确认，但是实际上好像对naver这种视频播放没什么作用。
    if(IS_IOS10_OR_HEIGHER){
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }else if (IS_IOS9_OR_HEIGHER){
        configuration.requiresUserActionForMediaPlayback = NO;
    }else if (IS_IOS8_OR_HEIGHER){
         configuration.mediaPlaybackRequiresUserAction = NO;
    }

    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.bounds configuration:configuration];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;//通过手势实现前进后退
   // webView.allowsLinkPreview = NO;
    
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = YES;
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    
    _realWebView = webView;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
    }
    else if([keyPath isEqualToString:@"title"])
    {
        self.title = change[NSKeyValueChangeNewKey];
    }else if([keyPath isEqualToString:@"loading"])
    {
        if ([self.delegate respondsToSelector:@selector(webViewIsLoadingEvent:)]) {
            [self.delegate webViewIsLoadingEvent:self];
        }
    }
}
-(void)initUIWebView
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.bounds];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    for (UIView *subview in [webView.scrollView subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            ((UIImageView *) subview).image = nil;
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.njkWebViewProgress = [[NDWebViewProgress alloc] init];
    webView.delegate = _njkWebViewProgress;
    _njkWebViewProgress.webViewProxyDelegate = self;
    _njkWebViewProgress.progressDelegate = self;
    
    _realWebView = webView;
}

#pragma mark- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(self.originRequest == nil)
    {
        self.originRequest = webView.request;
    }
    
    [self callback_webViewDidFinishLoad];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self callback_webViewDidStartLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self callback_webViewDidFailLoadWithError:error];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return resultBOOL;
}
- (void)webViewProgress:(NDWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    self.estimatedProgress = progress;
}

#pragma mark- WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if(![navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"]){
        self.currentRequest = navigationAction.request;
    }
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if(resultBOOL)
    {
//        self.currentRequest = navigationAction.request;
        if(navigationAction.targetFrame == nil)
        {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidStartLoad];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidFinishLoad];
    //[self setDocumnetCookie];
}
- (void)webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    //过滤掉对url加载cancel的alert处理
    NSLog(@"urlerrorCode:%zd",error.code);
    if(error.code == NSURLErrorTimedOut ||
       error.code == NSURLErrorCannotFindHost ||
       error.code == NSURLErrorCannotConnectToHost ||
       error.code == NSURLErrorNetworkConnectionLost ||
       error.code == NSURLErrorNotConnectedToInternet
    ){
        if (!self.hideLoadRequestErrorAlert) {
             [self showNetworkErrorAlert];
        }
    }
    [self callback_webViewDidFailLoadWithError:error];
}
- (void)webView: (WKWebView *)webView didFailNavigation:(WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}
//https请求 的权限认证 ios8下有bug并不走此方法，ios8下没有更好办法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
          } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
        
    } else {    
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        
    }
}
//ios9以上才调用，处理白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    if(webView)
        [webView reload];
}
#pragma mark- WKUIDelegate
//拦截js alert;
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    //防止在push present时打开alert 不能弹出造成崩溃
    if (!webView.URL ||![self getCurrentViewController] || [[self getCurrentViewController] presentedViewController] ||  ([self getCurrentViewController].navigationController &&![[self getCurrentViewController].navigationController.topViewController isEqual:[self getCurrentViewController]]) || ([self getCurrentViewController].navigationController &&[self getCurrentViewController].navigationController.presentedViewController)) {
        completionHandler();
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[NDCommonHelp getLocalize:@"confirm.ok"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    if([self getCurrentViewController]){
        [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }else{
        completionHandler();
    }
    
}
//拦截conform
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    if (!webView.URL ||![self getCurrentViewController] || [[self getCurrentViewController] presentedViewController] ||  ([self getCurrentViewController].navigationController &&![[self getCurrentViewController].navigationController.topViewController isEqual:[self getCurrentViewController]]) || ([self getCurrentViewController].navigationController &&[self getCurrentViewController].navigationController.presentedViewController)) {
        completionHandler(NO);
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[NDCommonHelp getLocalize:@"confirm.ok"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[NDCommonHelp getLocalize:@"confirm.cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    if([self getCurrentViewController]){
        [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }else{
        completionHandler(NO);
    }
}
//拦截prompt
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    if (!webView.URL ||![self getCurrentViewController] || [[self getCurrentViewController] presentedViewController] ||  ([self getCurrentViewController].navigationController &&![[self getCurrentViewController].navigationController.topViewController isEqual:[self getCurrentViewController]]) || ([self getCurrentViewController].navigationController &&[self getCurrentViewController].navigationController.presentedViewController)) {
        completionHandler(nil);
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
   
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:[NDCommonHelp getLocalize:@"confirm.ok"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alert.textFields[0].text);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[NDCommonHelp getLocalize:@"confirm.cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];

    if ([self getCurrentViewController]) {
         [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }else{
        completionHandler(nil);
    }
   

}
//处理window.open 在本webview打开这个网址
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
        //[self loadRequest:navigationAction.request];
        return nil;
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        //[self loadRequest:navigationAction.request];
        return nil;
    }
    return nil;
}
#pragma mark- CALLBACK NDVKWebView Delegate

- (void)callback_webViewDidFinishLoad
{
    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [self.delegate webViewDidFinishLoad:self];
    }
}
- (void)callback_webViewDidStartLoad
{
    if([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [self.delegate webViewDidStartLoad:self];
    }
}
- (void)callback_webViewDidFailLoadWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}
-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    BOOL resultBOOL = YES;
    if([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        if(navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}

#pragma mark- 基础方法
-(UIScrollView *)scrollView
{
    return [(id)self.realWebView scrollView];
}

- (id)loadRequest:(NSURLRequest *)request
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView loadRequest:request];
    }
    else
    {
//        NSString *hrefStr = [NSString stringWithFormat:@"%@%@%@", @"location.href='", request.URL.absoluteString, @"'"];
//        [(WKWebView *)self.realWebView evaluateJavaScript:hrefStr completionHandler:nil];
        if (self.currentRequest) {
            NSMutableURLRequest *requestM = [self.currentRequest mutableCopy];
            requestM.URL = request.URL;
            requestM.timeoutInterval = requestM.timeoutInterval >kTimeoutInterval ? kTimeoutInterval : requestM.timeoutInterval;
            [(WKWebView *)self.realWebView loadRequest:requestM];
            
            self.originRequest = [requestM copy];
        }else{
            NSMutableURLRequest *requestM = [request mutableCopy];
            requestM.timeoutInterval = kTimeoutInterval;
            
            self.originRequest = [requestM copy];
            [(WKWebView *)self.realWebView loadRequest:self.originRequest];
            
        }
    }
    
    return nil;
}
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    }
    else
    {
        return [(WKWebView*)self.realWebView loadHTMLString:string baseURL:baseURL];
    }
}
-(NSURLRequest *)currentRequest
{
    if(_usingUIWebView)
    {
        return [(UIWebView*)self.realWebView request];;
    }
    else
    {
        return _currentRequest;
    }
}
-(NSURL *)URL
{
    if(_usingUIWebView)
    {
        return [(UIWebView*)self.realWebView request].URL;;
    }
    else
    {
        return [(WKWebView*)self.realWebView URL];
    }
}
-(BOOL)isLoading
{
    return [self.realWebView isLoading];
}
-(BOOL)canGoBack
{
    return [self.realWebView canGoBack];
}
-(BOOL)canGoForward
{
    return [self.realWebView canGoForward];
}

- (id)goBack
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView goBack];
        return nil;
    }
    else
    {
        return [(WKWebView*)self.realWebView goBack];
    }
}
- (id)goForward
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView goForward];
        return nil;
    }
    else
    {
        return [(WKWebView*)self.realWebView goForward];
    }
}
- (id)reload
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView reload];
        return nil;
    }
    else
    {
        return [(WKWebView*)self.realWebView reload];
    }
}
- (id)reloadFromOrigin
{
    if(_usingUIWebView)
    {
        if(self.originRequest)
        {
            [self evaluateJavaScript:[NSString stringWithFormat:@"window.location.replace('%@')",self.originRequest.URL.absoluteString] completionHandler:nil];
        }
        return nil;
    }
    else
    {
        return [(WKWebView*)self.realWebView reloadFromOrigin];
    }
}
- (void)stopLoading
{
    [self.realWebView stopLoading];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if(_usingUIWebView)
    {
        NSString* result = [(UIWebView*)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if(completionHandler)
        {
            completionHandler(result,nil);
        }
    }
    else
    {
        return [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}
-(NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString
{
    if(_usingUIWebView)
    {
        NSString* result = [(UIWebView*)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        return result;
    }
    else
    {
        __block NSString* result = nil;
        __block BOOL isExecuted = NO;
        [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError *error) {
            result = obj;
            isExecuted = YES;
        }];
        
        while (isExecuted == NO) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return result;
    }
}
-(void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    if(_usingUIWebView)
    {
        UIWebView* webView = _realWebView;
        webView.scalesPageToFit = scalesPageToFit;
    }
    else
    {
        if(_scalesPageToFit == scalesPageToFit)
        {
            return;
        }
        //暂时注释掉，不设置scaleToFit-h5页面已经加入此设置 并且在电脑版下加入下面代码会出问题
        /*
        WKWebView* webView = _realWebView;
        
        NSString *jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width,initial-scale=1.0, maximum-scale=1.0,minimum-scale=1.0, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";
        
        if(scalesPageToFit)
        {
            WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [webView.configuration.userContentController addUserScript:wkUScript];
        }
        else
        {
            NSMutableArray* array = [NSMutableArray arrayWithArray:webView.configuration.userContentController.userScripts];
            for (WKUserScript *wkUScript in array)
            {
                if([wkUScript.source isEqual:jScript])
                {
                    [array removeObject:wkUScript];
                    break;
                }
            }
            for (WKUserScript *wkUScript in array)
            {
                [webView.configuration.userContentController addUserScript:wkUScript];
            }
        }
        */
    }
    
    _scalesPageToFit = scalesPageToFit;
}
-(BOOL)scalesPageToFit
{
    if(_usingUIWebView)
    {
        return [_realWebView scalesPageToFit];
    }
    else
    {
        return _scalesPageToFit;
    }
}

/**
 *  添加js回调oc通知方式，适用于 iOS8 之后
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    if ([_realWebView isKindOfClass:NSClassFromString(@"WKWebView")]) {
        [[(WKWebView *)_realWebView configuration].userContentController addScriptMessageHandler:scriptMessageHandler name:name];
    }
}

/**
 *  注销 注册过的js回调oc通知方式，适用于 iOS8 之后
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name
{
    if ([_realWebView isKindOfClass:NSClassFromString(@"WKWebView")]) {
        [[(WKWebView *)_realWebView configuration].userContentController removeScriptMessageHandlerForName:name];
    }
}

-(NSInteger)countOfHistory
{
    if(_usingUIWebView)
    {
        UIWebView* webView = self.realWebView;
        
        int count = [[webView stringByEvaluatingJavaScriptFromString:@"window.history.length"] intValue];
        if (count)
        {
            return count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        WKWebView* webView = self.realWebView;
        return webView.backForwardList.backList.count;
    }
}
-(void)gobackWithStep:(NSInteger)step
{
    if(self.canGoBack == NO)
        return;
    
    if(step > 0)
    {
        NSInteger historyCount = self.countOfHistory;
        if(step >= historyCount)
        {
            step = historyCount - 1;
        }
        
        if(_usingUIWebView)
        {
            UIWebView* webView = self.realWebView;
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.history.go(-%ld)", (long) step]];
        }
        else
        {
            WKWebView* webView = self.realWebView;
            WKBackForwardListItem* backItem = webView.backForwardList.backList[step];
            [webView goToBackForwardListItem:backItem];
        }
    }
    else
    {
        [self goBack];
    }
}
#pragma mark-  如果没有找到方法 去realWebView 中调用
-(BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL hasResponds = [super respondsToSelector:aSelector];
    if(hasResponds == NO)
    {
        hasResponds = [self.delegate respondsToSelector:aSelector];
    }
    if(hasResponds == NO)
    {
        hasResponds = [self.realWebView respondsToSelector:aSelector];
    }
    return hasResponds;
}
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* methodSign = [super methodSignatureForSelector:selector];
    if(methodSign == nil)
    {
        if([self.realWebView respondsToSelector:selector])
        {
            methodSign = [self.realWebView methodSignatureForSelector:selector];
        }
        else
        {
            methodSign = [(id)self.delegate methodSignatureForSelector:selector];
        }
    }
    return methodSign;
}
- (void)forwardInvocation:(NSInvocation*)invocation
{
    if([self.realWebView respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:self.realWebView];
    }
    else
    {
        [invocation invokeWithTarget:self.delegate];
    }
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction{
    _mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
    
    if([self.realWebView isKindOfClass:NSClassFromString(@"WKWebView")]){
        //此设置必须在wkWebView初始化之前设置才有作用。
//        if(IS_IOS10_OR_HEIGHER){
//            ((WKWebView *)self.realWebView).configuration.mediaTypesRequiringUserActionForPlayback = mediaPlaybackRequiresUserAction? WKAudiovisualMediaTypeAll:WKAudiovisualMediaTypeNone;
//        }else if (IS_IOS9_OR_HEIGHER){
//            ((WKWebView *)self.realWebView).configuration.requiresUserActionForMediaPlayback = mediaPlaybackRequiresUserAction;
//        }else if (IS_IOS8_OR_HEIGHER){
//            ((WKWebView *)self.realWebView).configuration.mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
//        }
        return;
    }else{
        ((UIWebView *)self.realWebView).mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction;
    }
}
#pragma mark- 清理
- (void)dealloc
{
    if(_usingUIWebView)
    {
        UIWebView* webView = _realWebView;
        webView.delegate = nil;
    }
    else
    {
        WKWebView* webView = _realWebView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [webView removeObserver:self forKeyPath:@"title"];
        [webView removeObserver:self forKeyPath:@"loading"];
    }
    [_realWebView scrollView].delegate = nil;
    [_realWebView stopLoading];
    [_realWebView removeFromSuperview];
    _realWebView = nil;
}
/** 获取当前View的控制器对象 */
- (UIViewController *)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
    if (self.delegate) {
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)self.delegate;
        }else{
            return  nil;
        }
    }
    return nil;
}

/**
  设置documentCookie
 */
- (void)setDocumnetCookie{
    NSString *loginCookie = nil;
    if ([[NLoginConnection sharedInstance] isLoggedIn]) {
        loginCookie  = [[NLoginConnection sharedInstance] getCookie];
    }
    NSString *cookieString = nil;
    
    if (loginCookie) {
        //DDLogInfo(@"%@", loginCookie);
        NSMutableString *cookieStr = [[NSMutableString alloc] init];
        [cookieStr appendString:@"var exp = new Date();exp.setTime(exp.getTime() + 24*60*60*90*1000);"];
        NSArray *cookieArray = [loginCookie componentsSeparatedByString:@";"];
        
        for (NSString *cookie in cookieArray) {
            NSString *tempCookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", cookie, @";domain=.naver.com;path=/;expires='+exp.toGMTString();"];
            [cookieStr appendString:tempCookieStr];
        }
        cookieString = [cookieStr copy];
        
    } else {
        cookieString = @"var exp = new Date();exp.setTime(exp.getTime() - 5);document.cookie = 'NID_AUT=-1;domain=.naver.com;path=/;expires='+exp.toGMTString(); document.cookie = 'NID_SES=-1;domain=.naver.com;path=/;expires='+exp.toGMTString(); document.cookie = 'nid_inf=-1;domain=.naver.com;path=/;expires='+exp.toGMTString();";
    }
    
    [self.realWebView evaluateJavaScript:cookieString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //NSLog(@"%@-%@",result,error);
    }];

}
- (void)setDocumnetCookieAndDeviceId{
    NSString *loginCookie = nil;
    if ([[NLoginConnection sharedInstance] isLoggedIn]) {
        loginCookie  = [[NLoginConnection sharedInstance] getCookie];
    }
    NSString *cookieString = nil;
    NSMutableString *cookieStr = [[NSMutableString alloc] init];
    [cookieStr appendString:@"var exp2 = new Date();exp2.setTime(exp2.getTime() + 30*365*24*60*60*1000);"];
    if (loginCookie) {
        //DDLogInfo(@"%@", loginCookie);
        [cookieStr appendString:@"var exp = new Date();exp.setTime(exp.getTime() + 24*60*60*90*1000);"];
        NSArray *cookieArray = [loginCookie componentsSeparatedByString:@";"];
        
        for (NSString *cookie in cookieArray) {
            NSString *tempCookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", cookie, @";domain=.naver.com;path=/;expires='+exp.toGMTString();"];
            [cookieStr appendString:tempCookieStr];
        }
        
    }else{
        [cookieStr appendString:@"var exp = new Date();exp.setTime(exp.getTime() - 5);"];
        NSString *tempCookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", @"NID_AUT=-1", @";domain=.naver.com;path=/;expires='+exp.toGMTString();"];
        [cookieStr appendString:tempCookieStr];
        
        tempCookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", @"NID_SES=-1", @";domain=.naver.com;path=/;expires='+exp.toGMTString();"];
        [cookieStr appendString:tempCookieStr];
        
        tempCookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", @"nid_inf=-1", @";domain=.naver.com;path=/;expires='+exp.toGMTString();"];
        [cookieStr appendString:tempCookieStr];
    }
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey];
    if (deviceId && ![deviceId isEqualToString:@""]) {
        NSString *device_cookieStr = [NSString stringWithFormat:@"%@=%@",@"NAVER_DICT_APP_PUSH_DEVICE_ID",[deviceId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSString *naver_dict_app_push_device_cookieStr = [NSString stringWithFormat:@"%@%@%@", @"document.cookie = '", device_cookieStr, @";domain=.naver.com;path=/;expires='+exp2.toGMTString();"];
        [cookieStr appendString:naver_dict_app_push_device_cookieStr];
    }
    cookieString = [cookieStr copy];
    [self.realWebView evaluateJavaScript:cookieString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //NSLog(@"%@-%@",result,error);
    }];
}
/**
 退出后从cookieStorage中清除登录的cookie
 */
+ (void)deleteLoginOutCookieFromCookieStorage{
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"NID_AUT"] || [cookie.name isEqualToString:@"NID_SES"] || [cookie.name isEqualToString:@"nid_inf"] ) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

// 네트워크연결어럿
- (void)showNetworkErrorAlert {
    if (self.alertView) {
        [self.alertView closeAlertView];
         self.alertView = nil;
    }
    for (UIView *view in [[[UIApplication sharedApplication] windows] firstObject].subviews) {
        if([view isKindOfClass:[NDCustomAlertView class]]){
            [view removeFromSuperview];
        }
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NDCommonHelp getLocalize:@"webview_network_error_dialog_content"]];
    NDCustomAlertView *alert = [[NDCustomAlertView alloc] init];
    self.alertView = alert;
    [alert setContainerView:[NDAlertHelper createMessageViewWithText:attributeString]];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:[NDCommonHelp getLocalize:@"confirm.cancel"], [NDCommonHelp getLocalize:@"webview_network_error_dialog_btn_retry"], nil]];
    [alert showWithSelectionButton];
    [alert setOnButtonTouchUpInside:^(NDCustomAlertView *alert, int buttonIndex) {
        if(buttonIndex == 1) {
            [self loadRequest:self.currentRequest];
        }else if(buttonIndex == 0){
            if ([self.delegate respondsToSelector:@selector(webViewFailedLoadingUrlAfterClickAlertViewCancel:)]) {
                [self.delegate performSelector:@selector(webViewFailedLoadingUrlAfterClickAlertViewCancel:) withObject:self];
            }
        }
        [alert closeAlertView];
    }];
}
- (void)setWKWebViewAllowsBackForwardNavigationGestures:(BOOL)WKWebViewAllowsBackForwardNavigationGestures{
    _WKWebViewAllowsBackForwardNavigationGestures = WKWebViewAllowsBackForwardNavigationGestures;
     ((WKWebView *)_realWebView).allowsBackForwardNavigationGestures = WKWebViewAllowsBackForwardNavigationGestures;
}

+ (void)deleteWebHistoryWithCookie_webBrowseHistory_cache:(DeleteWebHistory)deleteWebHistory withFiniedCallBack:(void (^)(bool finished))finishedCallBack{
    NSDate *dateForm = [NSDate dateWithTimeIntervalSince1970:0];
    NSSet *websiteDataTypes = nil;
    switch (deleteWebHistory) {
        case DeleteWebHistoryUrlHistory:
            break;
        case DeleteWebHistoryCookie:
            websiteDataTypes = [NSSet setWithArray:@[
                                                     WKWebsiteDataTypeLocalStorage,
                                                     WKWebsiteDataTypeCookies,
                                                     WKWebsiteDataTypeSessionStorage,
                                                     ]];
            break;
        case DeleteWebHistoryCaches:
            websiteDataTypes = [NSSet setWithArray:@[
                                                     WKWebsiteDataTypeDiskCache,
                                                     WKWebsiteDataTypeOfflineWebApplicationCache,
                                                     WKWebsiteDataTypeMemoryCache,
                                                     WKWebsiteDataTypeIndexedDBDatabases,
                                                     WKWebsiteDataTypeWebSQLDatabases
                                                     ]];
            break;
        default:
            break;
    }
    if (websiteDataTypes) {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateForm completionHandler:^{
            finishedCallBack(YES);
        }];
    }
}
@end
