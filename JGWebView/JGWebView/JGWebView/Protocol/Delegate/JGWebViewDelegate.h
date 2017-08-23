//
//  JGWebViewDelegate.h
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 此代理类为了回调系统webView的一般代理方法。如果还需要其他的代理方法，也可在此类做拓展或者自己开代理类 **/

@protocol JGWebView;
@protocol JGWebViewDelegate <NSObject>
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

@end
