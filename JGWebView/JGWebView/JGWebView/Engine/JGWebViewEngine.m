//
//  JGWebViewEngine.m
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWebViewEngine.h"
#import "JGUIWebViewFactory.h"
#import "JGWKWebViewFactory.h"

@interface JGWebViewEngine ()

/**  webView的类型  */
@property (nonatomic, assign) JGWebViewType type;

@end

@implementation JGWebViewEngine

#pragma - mark      ---------- 单例构造方法 ----------

static JGWebViewEngine *_instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

/**
 *  构造方法  -> 调用这个方法或者系统默认的init构造方法时，必须要将你要选择的webView的type传过来，不传就默认是UIWebView
 *
 *  @return webView引擎
 */
+ (id)shareWebViewEngine {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JGWebViewEngine alloc] init];
    });
    _instance.type = JGWebViewTypeForUIWebView;
    return _instance;
}

/**
 *  附带webView类型的JGWebViewType的构造方法
 *
 *  @param type webView类型的JGWebViewType
 *
 *  @return webView引擎
 */
+ (id)shareWebViewEngineWithType:(JGWebViewType)type {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JGWebViewEngine alloc] init];
    });
    _instance.type = type;
    return _instance;
}
/**
 *  获取webView
 */
- (id<JGWebViewFactory>)getWebViewFactory {
    
    id<JGWebViewFactory> factory = nil;
    switch (self.type) {
        case JGWebViewTypeForUIWebView:
        {
            factory = [[JGUIWebViewFactory alloc] init];
        }
            break;
        case JGWebViewTypeForWKWebView:
        {
            factory = [[JGWKWebViewFactory alloc] init];
        }
            break;
            
        default:
            break;
    }
    return factory;
}

@end
