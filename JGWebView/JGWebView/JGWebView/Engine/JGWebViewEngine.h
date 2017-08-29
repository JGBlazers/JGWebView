//
//  JGWebViewEngine.h
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGWebViewFactory.h"

typedef enum {
    JGWebViewTypeForUIWebView = 0,  // 默认是UIWebView
    JGWebViewTypeForWKWebView,
} JGWebViewType;

@interface JGWebViewEngine : NSObject

#pragma - mark      ---------- 单例构造方法 ----------
/**
 *  构造方法  -> 调用这个方法或者系统默认的init构造方法时，必须要将你要选择的webView的type传过来，不传就默认是UIWebView
 *
 *  @return webView引擎
 */
+ (id)shareWebViewEngine;

/**
 *  附带webView类型的JGWebViewType的构造方法
 *
 *  @param type webView类型的JGWebViewType
 *
 *  @return webView引擎
 */
+ (id)shareWebViewEngineWithType:(JGWebViewType)type;

/**
 *  修改浏览器的所属    注意-> 如果想要注册自己的agent，要在Appdelegate(入口类)中调用这个方法，然后将自己的agent传进来
 *
 *  @param agent 所属放标记
 */
+ (void)initWebViewUserAgent:(NSString *)agent;

/**
 *  获取webView
 */
- (id<JGWebViewFactory>)getWebViewFactory;

@end
