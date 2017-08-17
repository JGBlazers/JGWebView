//
//  JGWebViewUIDelegate.h
//  JGWebView
//
//  Created by FCG on 2017/8/11.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** ********** 此代理专门为了拓展wkWebView做准备的 ********** **********/
@protocol JGWebView;
@protocol JGWebViewUIDelegate <NSObject>

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

// ---------> 还有很多代理方法，按照需要拓展 ......

@end
