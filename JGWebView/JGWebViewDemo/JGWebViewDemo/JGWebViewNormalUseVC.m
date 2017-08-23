//
//  JGWebViewNormalUseVC.m
//  JGWebViewDemo
//
//  Created by FCG on 2017/8/23.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWebViewNormalUseVC.h"
#import "JGWebViewEngine.h"

@interface JGWebViewNormalUseVC ()<JGWebViewDelegate>

@end

@implementation JGWebViewNormalUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createWebView];
}

#pragma - mark      ---------- 创建WebView ----------
/**
 *  创建WebView
 */
- (void)createWebView {
    // 初始化引擎
    JGWebViewEngine *engine = [JGWebViewEngine shareWebViewEngineWithType:JGWebViewTypeForUIWebView];
    // 获取webView的工厂
    id <JGWebViewFactory> factory = [engine getWebViewFactory];
    // 拿到webView虚拟对象
    id <JGWebView> webView = [factory getWebViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    // 通过webView的虚拟对象，将webView添加到self.view上
    [self.view addSubview:[webView getView]];
    
    // webView的基本配置
    [webView setDelegate:self];
    
    [webView loadURLString:@"http://www.qisuu.com"];
    
    
}

#pragma - mark      ---------- JGWebViewDelegate ----------
/**
 *  将要开始加载
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 *  @param request 请求体
 *
 *  @return 是否允许加载
 */
- (BOOL)webView:(id<JGWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
    return YES;
}

/**
 *  正在加载
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)webViewDidStartLoad:(id<JGWebView>)webView {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  加载完成
 *
 *  @param webView webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载
 */
- (void)webViewDidFinishLoad:(id<JGWebView>)webView {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  获取当前加载的网页标题
 */
- (void)webView:(id<JGWebView>)webView getHtmlTitle:(NSString *)title {
    self.title = title;
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  获取当前加载的网页内容
 */
- (void)webView:(id<JGWebView>)webView getHtmlContent:(NSString *)content {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  加载失败
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 *  @param error   失败的对象
 */
- (void)webView:(id<JGWebView>)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  点击工具栏中的分享按钮
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)didClickToolBarForShareItemWithWebView:(id<JGWebView>)webView {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

#pragma - mark      ---------- JGWebViewUIDelegate ----------
/**
 *  webView关闭
 *
 *  @param webView webView
 */
- (void)webViewDidClose:(id<JGWebView>)webView {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  用户用足够的力触摸来弹出视图控制器，此方法将被调用。此时，你可以选择在app中展示弹出的视图控制器
 *
 *  @param webView                  webView
 *  @param previewingViewController 要弹出的控制器
 */
- (void)webView:(id<JGWebView>)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

@end
