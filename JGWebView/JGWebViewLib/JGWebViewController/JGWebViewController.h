//
//  JGWebViewController.h
//  JGWebView
//
//  Created by FCG on 2017/8/10.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGWebViewEngine.h"

@protocol JGWebVCDelegate <NSObject>
@optional
/**
 *  将要开始加载
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 *  @param request 请求体
 *
 *  @return 是否允许加载
 */
- (BOOL)webView:(id<JGWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request;
/**
 *  正在加载
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)webViewDidStartLoad:(id<JGWebView>)webView;

/**
 *  加载完成
 *
 *  @param webView webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载
 */
- (void)webViewDidFinishLoad:(id<JGWebView>)webView;

/**
 *  获取当前加载的网页标题
 */
- (void)webView:(id<JGWebView>)webView getHtmlTitle:(NSString *)title;

/**
 *  获取当前加载的网页内容
 */
- (void)webView:(id<JGWebView>)webView getHtmlContent:(NSString *)content;

/**
 *  加载失败
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 *  @param error   失败的对象
 */
- (void)webView:(id<JGWebView>)webView didFailLoadWithError:(NSError *)error;

/**
 *  点击工具栏中的分享按钮
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)didClickToolBarForShareItemWithWebView:(id<JGWebView>)webView;


/********** ********** 此代理专门为了拓展wkWebView做准备的 ********** **********/
/**
 *  webView关闭
 *
 *  @param webView webView
 */
- (void)webViewDidClose:(id<JGWebView>)webView;

/**
 *  用户用足够的力触摸来弹出视图控制器，此方法将被调用。此时，你可以选择在app中展示弹出的视图控制器
 *
 *  @param webView                  webView
 *  @param previewingViewController 要弹出的控制器
 */
- (void)webView:(id<JGWebView>)webView commitPreviewingViewController:(UIViewController *)previewingViewController;

@end

@interface JGWebViewController : UIViewController

// 拿到webView虚拟对象
@property (nonatomic, weak) id <JGWebView> webView;

/**  代理  */
@property (nonatomic, assign) id <JGWebVCDelegate> delegate;

/**
 *  如果用这个构造方法，就可以确定要使用的webView的类型，如果不使用这个构造方法，就默认用UIWebView加载
 *
 *  @param type webView的类型
 */
- (id)initWithWebViewEngineWithType:(JGWebViewType)type;

#pragma - mark      ---------- WebView的加载链接 ----------

/**
 *  使用WebView加载URLString的形式
 */
- (void)loadURLString:(NSString *)URLString;

/**
 *  使用WebView加载HTMLString的形式
 */
- (void)loadHTMLString:(NSString *)HTMLString;

#pragma - mark      ---------- 工具栏相关 ----------
/**
 *  是否需要工具条 默认是YES，带工具条的
 */
@property (nonatomic, assign) BOOL isNeedToolBar;

/**
 *  设置工具条的高度  默认50
 */
@property (nonatomic, assign) CGFloat toolBarHeight;

/**
 *  自定义工具条，如果自定义了工具条，一定要设置bounds  默认是用自带的toolBar
 */
@property (nonatomic, strong) UIView *toolBar;

#pragma - mark      ---------- loadingView ----------
/**
 *  是否要使用附带的loadingView  如果设置了这个属性为NO后，下面loadingView的基本配置的方法就不需要管了  默认需要YES
 */
@property (nonatomic, assign) BOOL isOpenLoadingView;

/**
 *  设置LoadingView的风格 默认JGLoadingStyleForLine
 */
@property (nonatomic, assign) JGLoadingStyle loadingStyle;

/**
 *  设置线条的高度 默认5
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  设置线条的颜色，默认红色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮 默认是异步加载
 */
@property (nonatomic, assign) BOOL isAsync;

/**
 *  设置加载圈圈的大小，默认是60， line类型的加载无关
 */
@property (nonatomic, assign) CGFloat roundWidth;

@end
