//
//  JGWKWebViewFactory.m
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWKWebViewFactory.h"
#import "JGWKWebView.h"

@interface JGWKWebViewFactory ()

/**  JGWKWebView webView的虚拟对象  */
@property (nonatomic, strong) JGWKWebView *wk_webView;

@end

@implementation JGWKWebViewFactory

/**
 *  创建WebView
 *
 *  @param frame webView的大小
 */
- (id<JGWebView>)getWebViewWithFrame:(CGRect)frame {
    self.wk_webView = [[JGWKWebView alloc] initWithFrame:frame];
    return self.wk_webView;
}

@end
