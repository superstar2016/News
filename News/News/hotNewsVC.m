//
//  hotNewsVC.m
//  News
//
//  Created by zhaobo on 2018/9/19.
//  Copyright © 2018年 zhaobo. All rights reserved.
//

#import "hotNewsVC.h"
#import "NDWKWebView/NDWebView.h"
#import "ALView+safeArea.h"
#import "NDWKWebView/NDJSNativeApiWrapper/NDJSNativeApiWrapper.h"
#import "NDWKWebView/NDWeakScriptMessageDelegate.h"
@interface hotNewsVC ()<NDWebViewDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)NDWebView *mainWebView;

@property (nonatomic,assign)BOOL setUpConstains;
@end

@implementation hotNewsVC
//资源释放
-(void)dealloc{
    //移除所有通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//    [self.appCommonNativeWarpper removeAllScriptMessageHandler:((WKWebView *)self.mainWebView.realWebView).configuration.userContentController];
//    [self.userTransWarpper removeAllScriptMessageHandler:((WKWebView *)self.mainWebView.realWebView).configuration.userContentController];
}
- (void)loadView{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViews];
    [self.view setNeedsUpdateConstraints];
}
- (void)updateViewConstraints{
    if (!self.setUpConstains) {
        [self.mainWebView autoPinEdgesToSuperviewSafeAreaWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        self.setUpConstains = YES;
    }
    
    [super updateViewConstraints];
}
- (void)addChildViews{
    self.mainWebView = [[NDWebView alloc] init];
    self.mainWebView.delegate = self;
    self.mainWebView.scalesPageToFit = YES;
    self.mainWebView.scrollView.delegate = self;
    self.mainWebView.scrollView.bounces = NO;
    self.mainWebView.opaque = NO;
    self.mainWebView.backgroundColor = [UIColor whiteColor];
    self.mainWebView.scrollView.scrollsToTop = YES;
    self.mainWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.mainWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.mainWebView.mediaPlaybackRequiresUserAction = NO;
    
    NDJSNativeApiWrapper *appCommonNativeWarpper = [[NDJSNativeApiWrapper alloc] initWithApiName:@"naverDictAppCommonNativeApi"];
    //self.appCommonNativeWarpper = appCommonNativeWarpper;
    
    [appCommonNativeWarpper addApiMethod:@"speechRecognize" withParam:@[@"langCode",@"dictType",@"isAutoClose"]];
    [appCommonNativeWarpper addApiMethod:@"startOCR"  withParam:@[@"ocrLang", @"transLang", @"dictType"]];
    [appCommonNativeWarpper addApiMethod:@"copyText"  withParam:@[@"text"]];
    [appCommonNativeWarpper addApiMethod:@"pasteText" withParam:@[]];
    [appCommonNativeWarpper addApiMethod:@"launchingSpeechPracticeModule" withParam:@[@"url"]];
    [appCommonNativeWarpper addApiMethod:@"openWebSettingPage" withParam:@[@"webSettingPageUrl"]];
    [appCommonNativeWarpper addApiMethod:@"startAbbyyOcr" withParam:@[@"originalLangCode",@"targetLangCode",@"dictType",@"serviceLogType"]];
    
    [appCommonNativeWarpper addApiMethod:@"launchingSpeechEvaluationModule" withParam:@[@"launchingUrl",@"isShowingRecArea"]];
    
    NDWeakScriptMessageDelegate *weakScriptMessageDele = [[NDWeakScriptMessageDelegate alloc] initWithDelegate:self];
    [appCommonNativeWarpper excuteWrapping:((WKWebView *)self.mainWebView.realWebView).configuration.userContentController withMessageHandler:weakScriptMessageDele];
    
    
    NDJSNativeApiWrapper *userTransWarpper = [[NDJSNativeApiWrapper alloc] initWithApiName:@"naverDictAppUserTransNativeApi"];
    //self.userTransWarpper = userTransWarpper;
    
    [userTransWarpper addApiMethod:@"startRecording" withParam:@[]];
    [userTransWarpper addApiMethod:@"stopRecording" withParam:@[]];
    [userTransWarpper addApiMethod:@"startPlaying" withParam:@[]];
    [userTransWarpper addApiMethod:@"pausePlaying" withParam:@[]];
    [userTransWarpper addApiMethod:@"stopPlaying" withParam:@[]];
    [userTransWarpper addApiMethod:@"uploadAudioFile" withParam:@[@"url",@"formFileName"]];
    
    [userTransWarpper excuteWrapping:((WKWebView *)self.mainWebView.realWebView).configuration.userContentController withMessageHandler:weakScriptMessageDele];
    
    [self.view addSubview:self.mainWebView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      NSLog(@"hot,News");
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}
// 网页URL截取操作
/*
- (BOOL)webView:(NDWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteUrl = request.URL.absoluteString;
    NSString *decodedPath = [absoluteUrl stringByRemovingPercentEncoding];
#ifdef DEBUG
    DDLogInfo(decodedPath);
#endif
    // 通过scheme进入其他应用
    if(request && [NDCommonHelp isOpenUrlByOtherAppScheme:request.URL]){
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    //  进入talktalk聊天页面，隐藏toolbar
    if(decodedPath) {
        if(([decodedPath rangeOfString:kTalkingRoonPattern].location != NSNotFound) &&
           [decodedPath rangeOfString:kTalkFullScreenPattern].location != NSNotFound) {
            self.swipeUp.enabled = NO;
            self.swipeDown.enabled = NO;
            if(!_isBottomHide){
                [self hideBottomView];
            }
        }else {
            self.swipeUp.enabled = YES;
            self.swipeDown.enabled = YES;
            if(_isBottomHide){
                [self showBottomView];
            }
        }
    }
    
    
    // 页面底部打开新窗口操作（전체앱=전체서비스, 고객센터, 오류신고, 네이버홈피）
    if(decodedPath){
        if(([decodedPath rangeOfString:kAllServicePattern].location != NSNotFound) ||
           ([decodedPath rangeOfString:kUserCenterPattern].location != NSNotFound) ||
           ([decodedPath rangeOfString:kUserCenterPattern3].location != NSNotFound)||
           ([decodedPath rangeOfString:kIssueReportPattern].location != NSNotFound)||
           ([decodedPath rangeOfString:kAllAppPattern].location != NSNotFound))
        {
            if([decodedPath rangeOfString:kTalkHomePattern].location == NSNotFound) {
                [self pushToAppWebBrowserWithUrl:absoluteUrl];
                return NO;
            }
        }
    }
    
    // 登录 (개인정보페이지패턴무시, 정상적인 로그인/로그아웃패턴이 아닌상황무시)
    if(decodedPath) {
        if(([decodedPath rangeOfString:kLoginPattern].location != NSNotFound) &&
           ([decodedPath rangeOfString:kUserInfoPattern].location == NSNotFound)) //&&
            //![decodedPath isEqualToString:URL_WITH_CODE(@"login_ignore_url")])
        {
            [self presentLoginView];
            if ([decodedPath isEqualToString:URL_WITH_CODE(@"login_ignore_url")]) {
                if ([webView canGoBack]) {
                    [webView goBack];
                }
            }
            return NO;
        }
        else if(([decodedPath rangeOfString:kLogoutPattern].location != NSNotFound) &&
                ([decodedPath rangeOfString:kUserInfoPattern].location == NSNotFound) &&
                ![decodedPath isEqualToString:URL_WITH_CODE(@"logout_ignore_url")])
        {
            [self presentLogoutView];
            return NO;
        }
    }
    // 通过scheme进入网页翻译详情页
    if(decodedPath && [decodedPath rangeOfString:kSiteTransDetailLaunchBySchemePattern].location != NSNotFound){
        [self presentSiteTransDetailPage:absoluteUrl];
        return NO;
    }
    // 网页翻译（包含pattern 但不能是编辑相关的）
    if(decodedPath && [decodedPath rangeOfString:kSiteTransDetailPattern].location != NSNotFound){
        if(([decodedPath rangeOfString:@"gnb.apptrans"].location == NSNotFound) &&
           ([decodedPath rangeOfString:@"gnb.dichome"].location == NSNotFound)) {
            if(([decodedPath rangeOfString:URL_WITH_CODE(@"naver_url")].location != NSNotFound) &&
               [decodedPath rangeOfString:@"gnb.naver"].location != NSNotFound) {
                [self naverButtonClicked];
                return NO;
            }
            if(([decodedPath rangeOfString:kSiteTransAddSitePattern].location == NSNotFound) &&
               ([decodedPath rangeOfString:kSiteTransAddSearchPattern].location == NSNotFound) &&
               ([decodedPath rangeOfString:kSiteTransEditBookmarkPattern].location == NSNotFound)){
                [self presentSiteTransDetailPage:absoluteUrl];
                return NO;
            }
        }
    }
    // 进入手写页面
    if(decodedPath && [decodedPath rangeOfString:kHandWriteChPattern].location != NSNotFound){
        [self presentHandWritePage:absoluteUrl];
        return NO;
    }
    // 弹出口译窗口
    if(decodedPath && [decodedPath rangeOfString:kTalkPopupPattern].location != NSNotFound){
        [self openTalkTransPopupPage:absoluteUrl];
        return NO;
    }
    // 发音评价
    if(decodedPath && [decodedPath rangeOfString:kPronEvalPattern].location != NSNotFound) {
        // 进入发音评价页面时，设置tabbar是否可见
        if([decodedPath rangeOfString:kPronEvalSetToolbarVisiblePattern].location != NSNotFound) {
            NSRange range = [decodedPath rangeOfString:kPronEvalSetToolbarVisiblePattern];
            NSString *isVisible = [decodedPath substringFromIndex:(range.location + range.length)];
            if([isVisible isEqualToString:@"true"]){
                self.swipeUp.enabled = YES;
                self.swipeDown.enabled = YES;
                if(_isBottomHide){
                    [self showBottomView];
                }
            }else if ([isVisible isEqualToString:@"false"]){
                self.swipeUp.enabled = NO;
                self.swipeDown.enabled = NO;
                if(!_isBottomHide){
                    [self hideBottomView];
                }
            }
            self.pronEvalPopupViewController = nil;
        }
        // 弹出发音评价窗口
        else {
            self.swipeUp.enabled = NO;
            self.swipeDown.enabled = NO;
            if(!_isBottomHide){
                [self hideBottomView];
            }
            [self openPronEvalPopupPage:decodedPath];
        }
        return NO;
    }
    //    // 发音评价网页共享
    //    if(decodedPath && [NDCommonHelp isWebSharePattern:decodedPath]) {
    //        [self showPronEvalWebSharePopupView:request];
    //        return NO;
    //    }
    
    if([decodedPath rangeOfString:@"wordbook/my.nhn"].location != NSNotFound) {
        _ismywordLink = YES;
    }else {
        _ismywordLink = NO;
    }
 
    if ([decodedPath rangeOfString:@"#"].location != NSNotFound) {
        if (!_timerForHash) {
            _timerForHash = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(prevAndNextButtonEnableSetting) userInfo:nil repeats:YES];
        }
    } else {
        if(_timerForHash) {
            [_timerForHash invalidate];
            _timerForHash = nil;
        }
    }
    
    return YES;
}
// 网页开始加载时的动画效果
- (void)webViewDidStartLoad:(NDWebView *)webView {
    [self addProgressView];
}
//页面加载完毕
- (void)webViewDidFinishLoad:(NDWebView *)webView {
    [self removeProgressView];
    
    NSString *decodedPath = [webView.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([decodedPath isEqualToString:@"about:blank"])
        return;
    
    // 设置最后使用的服务
    for(NSString *pattern in self.dictionaryServiceArray) {
        if(([decodedPath rangeOfString:pattern].location != NSNotFound) &&
           [decodedPath rangeOfString:kTalkMainPagePattern].location == NSNotFound) {
            [[NSUserDefaults standardUserDefaults] setObject:pattern forKey:kLastUseService];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
    }
    
    // 注入口译js
    if(decodedPath && [decodedPath rangeOfString:kTalkMainPagePattern].location != NSNotFound){
        [self.mainWebView evaluateJavaScript:kTalkTransJsInjection completionHandler:nil];
    }
}
//加载失败
- (void)webView:(NDWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeProgressView];
}
- (void)webViewIsLoadingEvent:(NDWebView *)webView{
    [self prevAndNextButtonEnableSetting];
}
*/
#pragma mark WKWebView监听JS调用OC的delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *function = message.name; //方法
    NSDictionary *parmeters = message.body; //参数
    //NSLog(@"%@-%@",function,parmeters);
    
//    if ([function isEqualToString:@"naverDictAppCommonNativeApi_speechRecognize"]) {
//        [self.jscoreApi OpenVoiceRecognizeWithLangCode:parmeters[@"langCode"] dictType:parmeters[@"dictType"] isAutoClose:[parmeters[@"isAutoClose"]boolValue]];
//    }else if ([function isEqualToString:@"naverDictAppCommonNativeApi_startOCR"]){
//        [self.jscoreApi startOCRWithLang:parmeters[@"ocrLang"] transTo:parmeters[@"transLang"] withDict:parmeters[@"dictType"]];
//    }else if  ([function isEqualToString:@"naverDictAppCommonNativeApi_launchingSpeechPracticeModule"]){
//        [self.jscoreApi launchingSpeechPracticeViewWithURL:parmeters[@"url"]];
//    }
//    else if  ([function isEqualToString:@"naverDictAppCommonNativeApi_launchingSpeechEvaluationModule"]){
//        [self openNewSpeechPracticePageWithUrl:parmeters[@"launchingUrl"] isShowingRecArea:[parmeters[@"isShowingRecArea"] boolValue]];
//    }
//    else if  ([function isEqualToString:@"naverDictAppCommonNativeApi_copyText"]){
//        [self.jscoreApi copyText:parmeters[@"text"]];
//    }else if  ([function isEqualToString:@"naverDictAppCommonNativeApi_pasteText"]){
//        [self.jscoreApi pasteText];
//    }else if  ([function isEqualToString:@"naverDictAppCommonNativeApi_openWebSettingPage"]){
//        [self.jscoreApi openWebSettingPage:parmeters[@"webSettingPageUrl"]];
//    }else if ([function isEqualToString:@"naverDictAppCommonNativeApi_startAbbyyOcr"]){
//        [self.jscoreApi startRTROCRWithOriginal:parmeters[@"originalLangCode"] targetLanCode:parmeters[@"targetLangCode"] withDict:parmeters[@"dictType"] serviceLogType:parmeters[@"serviceLogType"]];
//    }
//
//    if ([function isEqualToString:@"naverDictAppUserTransNativeApi_startRecording"]) {
//        [self.usertTransJscoreApi startRecording];
//    }else if ([function isEqualToString:@"naverDictAppUserTransNativeApi_stopRecording"]){
//        [self.usertTransJscoreApi stopRecording];
//    }else if  ([function isEqualToString:@"naverDictAppUserTransNativeApi_startPlaying"]){
//        [self.usertTransJscoreApi startPlaying];
//    }else if  ([function isEqualToString:@"naverDictAppUserTransNativeApi_stopPlaying"]){
//        [self.usertTransJscoreApi stopPlaying];
//    }else if  ([function isEqualToString:@"naverDictAppUserTransNativeApi_pausePlaying"]){
//        [self.usertTransJscoreApi pausePlaying];
//    }else if  ([function isEqualToString:@"naverDictAppUserTransNativeApi_uploadAudioFile"]){
//        [self.usertTransJscoreApi uploadAudioFileWithUrl:parmeters[@"url"] withFormFileName:parmeters[@"formFileName"]];
//    }
    
}
@end
