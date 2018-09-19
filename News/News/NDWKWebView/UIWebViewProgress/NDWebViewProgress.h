//
//  NDWebViewProgress.h
//
//  Created by zhabo on 2016/09/21.
//  Copyright (c) 2016 Naver. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef ND_weak
#if __has_feature(objc_arc_weak)
#define ND_weak weak
#else
#define ND_weak unsafe_unretained
#endif

extern const float NDInitialProgressValue;
extern const float NDInteractiveProgressValue;
extern const float NDFinalProgressValue;

typedef void (^NDWebViewProgressBlock)(float progress);
@protocol NDWebViewProgressDelegate;
@interface NDWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, ND_weak) id<NDWebViewProgressDelegate>progressDelegate;
@property (nonatomic, ND_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NDWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol NDWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(NDWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

