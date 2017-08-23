//
//  JGUIWebViewFactory.m
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGUIWebViewFactory.h"
#import "JGUIWebView.h"

@interface JGUIWebViewFactory ()

@end

@implementation JGUIWebViewFactory

/**
 *  创建WebView
 *
 *  @param frame webView的大小
 */
- (id<JGWebView>)getWebViewWithFrame:(CGRect)frame {
    return [[JGUIWebView alloc] initWithFrame:frame];
}

@end
