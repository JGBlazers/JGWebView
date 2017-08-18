//
//  JGWebView.h
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGWebView.h"
#import "JGWebViewDelegate.h"
#import "JGWebViewUIDelegate.h"
#import "JGLoadingEngine.h"

typedef void(^JGCloseBlock)();
typedef void(^JGLoadingViewBlock)(id<JGLoadingView>loadingView);

@protocol JGWebView <NSObject>

#pragma - mark      ---------- 初始化方法 ----------

/**
 *  初始化webView的方法
 *
 *  @param frame webView的frame
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  获取到webView的父视图(跟视图)，在做添加视图的时候，一定要调用这个方法添加到想要的视图上去
 *  如[<UIView> addSubview:[外部webView的对象调用这个方法 getView]];
 */
- (UIView *)getView;

/**
 *  获取实际上的webView，如果想要获取到实际上的webView，就要调用这个方法
 */
- (UIView *)getWebView;

/**
 *  设置代理，设置了之后代理方法就会调用，不设置代理的情况下，也不会加载代理方法
 */
- (void)setDelegate:(id<JGWebViewDelegate>)delegate;

/**
 *  此代理是为了WKWebView拓展的，如果不需要或者是使用UIWebView时，可以不调用次方法
 */
- (void)setUIDelegate:(id<JGWebViewUIDelegate>)ui_delegate;

#pragma - mark      ---------- 工具栏相关 ----------

/**
 *  是否需要工具条 默认是YES，带工具条的
 *
 *  @param isNeed 是否需要
 */
- (void)isNeedToolBar:(BOOL)isNeed;

/**
 *  设置工具条的高度  默认60
 *
 *  @param height 高度
 */
- (void)setToolBarForHeight:(CGFloat)height;

/**
 *  自定义工具条，如果自定义了工具条，一定要设置bounds
 *
 *  @param toolBar 自定义的工具条
 */
- (void)setCustomToolBar:(UIView *)toolBar;

#pragma - mark      ---------- WebView的加载链接 ----------

/**
 *  使用WebView加载NSURLRequest的形式
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 *  使用WebView加载URL的形式
 */
- (void)loadURL:(NSURL *)URL;

/**
 *  使用WebView加载URLString的形式
 */
- (void)loadURLString:(NSString *)URLString;

/**
 *  使用WebView加载HTMLString的形式
 */
- (void)loadHTMLString:(NSString *)HTMLString;

#pragma - mark      ---------- 控制WebView的基本方法 ----------

/**
 *  返回上一页
 */
- (void)goBack;

/**
 *  前往下一页
 */
- (void)goForward;

/**
 *  刷新当前页
 */
- (void)reLoadCurrentPage;

/**
 *  关闭webView，如果不实现的情况下，默认是优先pop出栈，pop不行就考虑dismis下模态
 */
- (void)closeWebViewWithCloseBlock:(JGCloseBlock)cBlock;

#pragma - mark      ---------- loadingView ----------
/**
 *  是否要使用附带的loadingView  如果设置了这个属性后，下面loadingView的基本配置的方法就不需要管了
 */
- (void)isOpenLoadingView:(BOOL)isOpenLoadingView;

/**
 *  设置LoadingView的风格
 */
- (void)setLoadingViewStyle:(JGLoadingStyle)style;

/**
 *  设置线条的高度 默认5
 */
- (void)setLineWidth:(CGFloat)lineWidth;

/**
 *  设置线条的颜色，默认红色
 */
- (void)setLineColor:(UIColor *)lineColor;

/**
 *  是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮
 *
 *  @param isAsync 是否异步  默认是异步加载
 */
- (void)setIsAsyncLoading:(BOOL)isAsync;

/**
 *  设置加载圈圈的大小，默认是50， line类型的加载无关
 */
- (void)setRoundWidth:(CGFloat)roundWidth;

@end
