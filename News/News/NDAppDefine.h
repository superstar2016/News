//
//  NDAppDefine.h
//  naverdicapp
//
//  Created by naver on 16/2/18.
//  Copyright © 2016年 Naver_China. All rights reserved.
//

#ifndef NDAppDefine_h
#define NDAppDefine_h

#import "AppDelegate.h"

#define IS_IOS7_OR_HEIGHER      \
(([[UIDevice currentDevice].systemVersion floatValue] >=7.0) ? YES:NO)


#define IS_IOS8_OR_HEIGHER      \
(([[UIDevice currentDevice].systemVersion floatValue] >=8.0) ? YES:NO)

#define IS_IOS9_OR_HEIGHER      \
(([[UIDevice currentDevice].systemVersion floatValue] >=9.0) ? YES:NO)

#define IS_LOWER_IOS9_HEIGHER_IOS8      \
(([[UIDevice currentDevice].systemVersion floatValue] <9.0) ? YES:NO) && (([[UIDevice currentDevice].systemVersion floatValue] >=8.0) ? YES:NO)

#define IS_IOS10_OR_HEIGHER      \
(([[UIDevice currentDevice].systemVersion floatValue] >=10.0) ? YES:NO)

#define IS_IOS11_OR_HEIGHER      \
(([[UIDevice currentDevice].systemVersion floatValue] >=11.0) ? YES:NO)

#define HEX_COLOR(c,a)          \
[UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:(a)]
#define UIColorWithRGB(r, g, b) \
[UIColor colorWithRed:1.0*(r)/0xff green:1.0*(g)/0xff blue:1.0*(b)/0xff alpha:1.0]

#define UIColorWithRGB_alpha(r, g, b,a) \
[UIColor colorWithRed:1.0*(r)/0xff green:1.0*(g)/0xff blue:1.0*(b)/0xff alpha:(a)]

#define IS_IPHONE               \
(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_Ipad               \
(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONEX  \
([NDDeviceHelper isIphoneX])

#define DOCUMENT_PATH      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FIRST_USE_PATH     [DOCUMENT_PATH stringByAppendingPathComponent:@"FirstUse.xml"]
#define GUIDE_OPEN_PATH    [DOCUMENT_PATH stringByAppendingPathComponent:@"GuideOpenFile"]
#define APP_DELEGATE       ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define FILE_MANAGER       [NSFileManager defaultManager]
#define USER_DEFAULTS      [NSUserDefaults standardUserDefaults]
#define MAIN_BUNDLE        [NSBundle mainBundle]
#define BOUNDS_WIDTH       [UIScreen mainScreen].bounds.size.width
#define BOUNDS_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define FRAME_WIDTH        [UIScreen mainScreen].applicationFrame.size.width
#define FRAME_HEIGHT       [UIScreen mainScreen].applicationFrame.size.height
#define SCREEN_SCALE       [UIScreen mainScreen].scale
#define TOP                ([NDDeviceHelper isIphoneX] ? 44 : 20)
#define Bottom             ([NDDeviceHelper isIphoneX] ? 34 : 0)
#define IPHONE_4_Landscape 300
#define IPHONE_4_Portrait  320
#define SD_WEB_IMAGE_CACHE_TIME (15 * 24 * 60 * 60)
#define HotAndNew_CACHE_TIME  (7 *24 * 60 * 60)//hot&new 缓存时间 7天

#define kToolBarHeight            50
//#define kMymenuHeight           430
#define kNavigateHeight           45
#define kMorePopWidth             136
#define kMorePopHeight            82
#define kMyMenuList               @"mymenuList"
#define kMyHomeDict               @"myhomeDict"
#define KHotAndNewDictList        @"myhotAndNewDictList" //hotAndNew key
//#define kUpdateNoticeReadOrNo   @"updateAlert"
#define kCopyUrlActionReadOrNot   @"copyurlAction"
#define kAppWebBrowserNotify      @"presentAppWebBrowserNotify"
#define kIsShowWebtransGuide      @"isShowWebtransGuide"
#define kLcsEndTime               @"kLcsEndTime"
#define kLcsStartTime             @"kLcsStartTime"
#define kStoredCopyText           @"storedCopyText"
#define kSDWebImageLastCacheTime  @"sdWebImageLastCacheTime"
#define kHotAndNewCacheTime       @"HotAndNewLastCacheTime"
//获取词典推送设置接口的上一次时间
#define kDictPushSettingCachedLastTime       @"dictPushSettingCachedLastTime"
#define kDictPushSetting_Cache_Time          2 //(1*(24 * 60* 60))
#define KDictPushSettingList        @"dictPushSettingList"

// 安装 NAVER APP 相关
#define kNaverSchemeSlash      @"naversearchapp://"
#define kNaverInstalledUrl     @"naversearchapp://default?version=1"
#define NAVER_APP_STORE_URL    \
@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=393499958&mt=8"

// 底部超链接pattern
#define kAllServicePattern   @"services.html?"
#define kUserCenterPattern   @"support/service/main.nhn?serviceNo="
#define kUserCenterPattern3  @"serviceMain.nhn?"
#define kIssueReportPattern  @"support/issue/report.nhn?serviceNo="
#define kAllAppPattern       @"/application/safariApp.nhn"

// 登陆相关pattern
#define kLoginPattern        @"nid.naver.com/nidlogin.login"
#define kLogoutPattern       @"nid.naver.com/nidlogin.logout"
#define kUserInfoPattern     @"nid.naver.com/mobile/user/help/myInfo"

// 进入网页翻译详情pattern
#define kSiteTransDetailLaunchBySchemePattern  \
@"naverdicapp://launching?launchingPage=webTrans&transurl"
#define kSiteTransDetailPattern          @"nsc=Mtranslate.apptrans"
#define kSiteTransEditBookmarkPattern    @"bookmarkEdit.dic"
#define kSiteTransAddSitePattern         @"add.dic"
#define kSiteTransAddSearchPattern       @"addsearch.dic"

// 手写输入页面相关pattern
#define kHandWriteChPattern    @"m.cndic.naver.com/html/writing.html"
#define kHandWriteClosePattern @"iosnaverdic/inputmethod/"

// 口译窗口pattern
#define kTalkMainPagePattern   @".naver.com/talk"
#define kTalkPopupPattern      @".naver.com/talk/iosnaverdic/"
#define kTalkKrAudioPattern    @"talk/iosnaverdic/kr"
#define kTalkJpAudioPattern    @"talk/iosnaverdic/jp"
#define kTalkTransJsInjection  \
@"window.naverdicKrJpTrans={};window.naverdicKrJpTrans.showSpeechRec=function(index){location.href='talk/iosnaverdic/'+ index;};"
#define kTalkHmacServerHost    @"vrecog.search.naver.com"
#define kTalkHmacKrPort        10309
#define kTalkHmacJpPort        12000
#define kTalkTypeKrJp          @"type=kr2jp&auto=1&q="
#define kTalkTypeJpKr          @"type=jp2kr&auto=1&q="

// 发音评价pattern
#define kPronEvalPattern          @"naver.com/proneval/iosnaverdic/"
#define kPronEvalSetToolbarVisiblePattern  @"nativeApi/setTabBarVisible/"

// talktalk pattern
#define kTalkHomePattern        @"https://dict.naver.com/talkie"
#define kTalkingRoonPattern     @"talk.naver.com"
#define kTalkFullScreenPattern  @"#nafullscreen"
#define DefineWeakSelf  __weak typeof(self) weakSelf = self
//用于推送注册
#define kDeviceTokenKey  @"_deviceToken_"
#define kLanguageCodeKey @"_language_code_"
#define kLasetUserIdKey  @"_userId_"

#ifdef DEV

#define URL_WITH_CODE(code)   \
[[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceCodeURL" ofType:@"plist"]] objectForKey:code] objectForKey:@"devUrl"]

#define SITE_TRANS_INJECT_SCRIPT      \
@"void function(e){var t=setInterval(function(){if(e&&e.getElementsByTagName&&e.getElementById&&e.body){clearInterval(t);t=null;var j=window.location.href.indexOf(\"https\")==0?\"https\":\"http\";var n=e.createElement(\"script\");n.id=\"NaverTranslator-seeds\";n.charset=\"utf-8\",n.setAttribute(\"src\",j+\"://dev.app.translate.naver.net/js/DevNaverTranslator.js?svc_code=naver_dict_mobile&\"+Date.parse(new Date));e.body.appendChild(n)}},10)}(document)"

#define NOTICE_SERVICE_TYPE  kNoticeServerTypeRealTest
//#define NOTICE_SERVICE_TYPE  kNoticeServerTypeReal

#define GET_DICT_LIST_API       @"https://dev.dict.naver.com/getdictlist.dict"
#define GET_FAVORITE_LIST_API   @"https://dev.dict.naver.com/favoritelist.dict"
#define GET_ICON_LINK_URL       @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg"
#define GET_ICON_LINK_URL_2X    @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg/2x"

#define KO_EN_TRANSLATE_URL     @"https://papago.naver.com/?sk=ko&tk=en&st="
#define Auto_KO_TRANSLATE_URL   @"https://papago.naver.com/?sk=auto&tk=ko&st="

//获取hotAndNewDictList_API
#define GET_HotAndNew_DICTLIST_API  \
@"https://dev.dict.naver.com/getHotAndNewDictlist.dict?os_code="
//语音识别client_ID
#define Client_ID  @"tvCMOGdTMtoNVPs6Wfyt"

/*apnsPush相关使用*/
//传递deviceToken给Server
#define Channelgw_API  \
@"https://dev-gateway.dict.naver.com"

#define KProviderUrl_SaveDeviceInfor  [NSString stringWithFormat:@"%@%@",Channelgw_API,@"/app/saveInfo"]
//在npush注册的service_id
#define KService_id                   @"APG00355"
//在npush注册的service_key
#define KService_key                  @"4c1e2992-50f2-4b2e-b340-a76f4737d490"
//获取各个词典业务的推送设置API
#define GET_DictPushSettings_API  \
@"http://10.113.250.222:3001/dev/naverdicapp_push_setting_info.json"

#define  kAbbyyRtrSdkLicense   @"AbbyyRtrSdk_InHouse.License"
//获取广告配置信息
#define kGetAdeversingSettingAPI_Url @"https://dev.dict.naver.com/app/dict/static-assets/naverdicapp_popup_message.json"
#else
#ifdef STAGE

#define URL_WITH_CODE(code)   \
[[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceCodeURL" ofType:@"plist"]] objectForKey:code] objectForKey:@"stgUrl"]

#define SITE_TRANS_INJECT_SCRIPT      \
@"void function(e){var t=setInterval(function(){if(e&&e.getElementsByTagName&&e.getElementById&&e.body){clearInterval(t);t=null;var j=window.location.href.indexOf(\"https\")==0?\"https\":\"http\";var n=e.createElement(\"script\");n.id=\"NaverTranslator-seeds\";n.charset=\"utf-8\",n.setAttribute(\"src\",j+\"://stg.app.translate.naver.net/js/StgNaverTranslator.js?svc_code=naver_dict_mobile&\"+Date.parse(new Date));e.body.appendChild(n)}},10)}(document)"

#define NOTICE_SERVICE_TYPE  kNoticeServerTypeRealTest
//#define NOTICE_SERVICE_TYPE  kNoticeServerTypeReal

#define GET_DICT_LIST_API       @"https://stg.dict.naver.com/getdictlist.dict"
#define GET_FAVORITE_LIST_API   @"https://stg.dict.naver.com/favoritelist.dict"
#define GET_ICON_LINK_URL       @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg"
#define GET_ICON_LINK_URL_2X    @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg/2x"

#define KO_EN_TRANSLATE_URL     @"https://papago.naver.com/?sk=ko&tk=en&st="
#define Auto_KO_TRANSLATE_URL   @"https://papago.naver.com/?sk=auto&tk=ko&st="

//获取hotAndNewDictList_API
#define GET_HotAndNew_DICTLIST_API  \
@"https://stg.dict.naver.com/getHotAndNewDictlist.dict?os_code="

//语音识别client_ID
#define Client_ID  @"tvCMOGdTMtoNVPs6Wfyt"

#define Channelgw_API  \
@"https://stg-gateway.dict.naver.com"
/*apnsPush相关使用*/
//传递deviceToken给Server
#define KProviderUrl_SaveDeviceInfor  [NSString stringWithFormat:@"%@%@",Channelgw_API,@"/app/saveInfo"]
//在npush注册的service_id
#define KService_id                   @"APG00355"
//在npush注册的service_key
#define KService_key                  @"4c1e2992-50f2-4b2e-b340-a76f4737d490"
//获取各个词典业务的推送设置API
#define GET_DictPushSettings_API  \
@"http://10.113.250.222:3001/stg/naverdicapp_push_setting_info.json"

#define  kAbbyyRtrSdkLicense   @"AbbyyRtrSdk_InHouse.License"
//获取广告配置信息
#define kGetAdeversingSettingAPI_Url @"https://stg.dict.naver.com/app/dict/static-assets/naverdicapp_popup_message.json"
#else
#ifdef REAL

#define URL_WITH_CODE(code)   \
[[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceCodeURL" ofType:@"plist"]] objectForKey:code] objectForKey:@"realUrl"]

#define SITE_TRANS_INJECT_SCRIPT      \
@"void function(e){var t=setInterval(function(){if(e&&e.getElementsByTagName&&e.getElementById&&e.body){clearInterval(t);t=null;var j=window.location.href.indexOf(\"https\")==0?\"https\":\"http\";var n=e.createElement(\"script\");n.id=\"NaverTranslator-seeds\";n.charset=\"utf-8\",n.setAttribute(\"src\",j+\"://app.translate.naver.net/js/NaverTranslator.js?svc_code=naver_dict_mobile&\"+Date.parse(new Date));e.body.appendChild(n)}},10)}(document)"

//#define NOTICE_SERVICE_TYPE  kNoticeServerTypeRealTest
#define NOTICE_SERVICE_TYPE  kNoticeServerTypeReal

#define MDict_REAL_API          @"https://dict.naver.com"
#define GET_DICT_LIST_API       [NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"getdictlist.dict"]
#define GET_FAVORITE_LIST_API   [NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"favoritelist.dict"]
#define GET_ICON_LINK_URL       @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg"
#define GET_ICON_LINK_URL_2X    @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg/2x"

#define KO_EN_TRANSLATE_URL     @"https://papago.naver.com/?sk=ko&tk=en&st="
#define Auto_KO_TRANSLATE_URL   @"https://papago.naver.com/?sk=auto&tk=ko&st="

//获取hotAndNewDictList_API
#define GET_HotAndNew_DICTLIST_API  \
[NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"getHotAndNewDictlist.dict?os_code="]

//语音识别client_ID
#define Client_ID  @"tvCMOGdTMtoNVPs6Wfyt"
#define Channelgw_API  \
@"https://gateway.dict.naver.com"
/*apnsPush相关使用*/
//传递deviceToken给Server
#define KProviderUrl_SaveDeviceInfor [NSString stringWithFormat:@"%@%@",Channelgw_API,@"/app/saveInfo"]
//在npush注册的service_id
#define KService_id                   @"APG00355"
//在npush注册的service_key
#define KService_key                  @"4c1e2992-50f2-4b2e-b340-a76f4737d490"
//获取各个词典业务的推送设置API
#define GET_DictPushSettings_API      @"https://dict.naver.com/naverdicapp_push_setting_info.json"

#define  kAbbyyRtrSdkLicense   @"AbbyyRtrSdk_InHouse.License"
//获取广告配置信息
#define kGetAdeversingSettingAPI_Url @"https://dict.naver.com/app/dict/static-assets/naverdicapp_popup_message.json"
#else

#define URL_WITH_CODE(code)   \
[[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceCodeURL" ofType:@"plist"]] objectForKey:code] objectForKey:@"realUrl"]

#define SITE_TRANS_INJECT_SCRIPT      \
@"void function(e){var t=setInterval(function(){if(e&&e.getElementsByTagName&&e.getElementById&&e.body){clearInterval(t);t=null;var j=window.location.href.indexOf(\"https\")==0?\"https\":\"http\";var n=e.createElement(\"script\");n.id=\"NaverTranslator-seeds\";n.charset=\"utf-8\",n.setAttribute(\"src\",j+\"://app.translate.naver.net/js/NaverTranslator.js?svc_code=naver_dict_mobile&\"+Date.parse(new Date));e.body.appendChild(n)}},10)}(document)"

#define NOTICE_SERVICE_TYPE  kNoticeServerTypeReal

#define MDict_REAL_API          @"https://dict.naver.com"
#define GET_DICT_LIST_API       [NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"getdictlist.dict"]
#define GET_FAVORITE_LIST_API   [NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"favoritelist.dict"]
#define GET_ICON_LINK_URL       @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg"
#define GET_ICON_LINK_URL_2X    @"https://ssl.pstatic.net/dicimg/naverdicapp/favimg/2x"

#define KO_EN_TRANSLATE_URL     @"https://papago.naver.com/?sk=ko&tk=en&st="
#define Auto_KO_TRANSLATE_URL   @"https://papago.naver.com/?sk=auto&tk=ko&st="

//获取hotAndNewDictList_API
#define GET_HotAndNew_DICTLIST_API  \
[NSString stringWithFormat:@"%@/%@",MDict_REAL_API,@"getHotAndNewDictlist.dict?os_code="]

//语音识别client_ID
#define Client_ID  @"NQqNJQbxRpEb9aLqDk7r"
#define Channelgw_API  \
@"https://gateway.dict.naver.com"
/*apnsPush相关使用*/
//传递deviceToken给Server
#define KProviderUrl_SaveDeviceInfor  [NSString stringWithFormat:@"%@%@",Channelgw_API,@"/app/saveInfo"]
//在npush注册的service_id
#define KService_id                   @"APG00355"
//在npush注册的service_key
#define KService_key                  @"4c1e2992-50f2-4b2e-b340-a76f4737d490"
//获取各个词典业务的推送设置API
#define GET_DictPushSettings_API  @"https://dict.naver.com/naverdicapp_push_setting_info.json"
//abbabyLicense
#define  kAbbyyRtrSdkLicense   @"AbbyyRtrSdk_Real.License"
//获取广告配置信息
#define kGetAdeversingSettingAPI_Url @"https://dict.naver.com/app/dict/static-assets/naverdicapp_popup_message.json"
#endif
#endif
#endif




#define kLastUseService     @"lastuse"
#define kTermsPattern       @"m.terms.naver.com"
#define kKoreanPattern      @"ko.dict.naver.com"
#define kEnglishPattern     @"endic.naver.com"
#define kJapanesePattern    @"ja.dict.naver.com"
#define kChinesePattern     @"m.cndic.naver.com"
#define kHanjaPattern       @"hanja.dict.naver.com"
#define kOpendictPattern    @"opendict.naver.com"
#define kAlbanianPattern    @"dict.naver.com/sqkodict"
#define kArabicPattern      @"dict.naver.com/arkodict"
#define kPolishPattern      @"dict.naver.com/plkodict"
#define kPersianPattern     @"dict.naver.com/fakodict"
#define kGermanPattern      @"dict.naver.com/dekodict"
#define kRussianPattern     @"dict.naver.com/rukodict"
#define kFrancePattern      @"dict.naver.com/frkodict"
#define kGeorgianPattern    @"dict.naver.com/kakodict"
#define kDutchPattern       @"dict.naver.com/nlkodict"
#define kCzechPattern       @"dict.naver.com/cskodict"
#define kCambodianPattern   @"dict.naver.com/kmkodict"
#define kLatinPattern       @"dict.naver.com/lakodict"
#define kRomanianPattern    @"dict.naver.com/rokodict"
#define kMongolianPattern   @"dict.naver.com/mnkodict"
#define kPortuguesePattern  @"dict.naver.com/ptkodict"
#define kSwedishPattern     @"dict.naver.com/svkodict"
#define kSwahiliPattern     @"dict.naver.com/swkodict"
#define kTurkishPattern     @"dict.naver.com/trkodict"
#define kThaiPattern        @"dict.naver.com/thkodict"
#define kUzbekPattern       @"dict.naver.com/uzkodict"
#define kUkrainianPattern   @"dict.naver.com/ukkodict"
#define kSpanishPattern     @"dict.naver.com/eskodict"
#define kHungarianPattern   @"dict.naver.com/hukodict"
#define kItalianPattern     @"dict.naver.com/itkodict"
#define kVietnamesePattern  @"dict.naver.com/vikodict"
#define kHindiPattern       @"dict.naver.com/hikodict"
#define kIndonesianPattern  @"dict.naver.com/idkodict"

#endif
