//
//  JGWebViewController.m
//  JGWebView
//
//  Created by FCG on 2017/8/10.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWebViewController.h"

@interface JGWebViewController ()<JGWebViewDelegate, JGWebViewUIDelegate>

/**  webView的类型  */
@property (nonatomic, assign) JGWebViewType type;

@end

@implementation JGWebViewController

- (void)dealloc
{
    NSLog(@"class == %@  line == %zd  func == %s", [self class], __LINE__, __FUNCTION__);
}

/**
 *  如果用这个构造方法，就可以确定要使用的webView的类型，如果不使用这个构造方法，就默认用UIWebView加载
 *
 *  @param type webView的类型
 */
- (id)initWithWebViewEngineWithType:(JGWebViewType)type {
    if (self = [super init]) {
        _type = type;
        // 初始化
        [self configWebViewAttribute];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        [self configWebViewAttribute];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建WebView
    [self createWebView];
}

#pragma - mark      ---------- 为webView的基本配置做初始化 此初始化必要性很大 ----------
- (void)configWebViewAttribute {
    
    _isOpenLoadingView = YES;
    _loadingStyle = JGLoadingStyleForLine;
    _lineWidth = 5;
    _lineColor = [UIColor redColor];
    _isAsync = YES;
    _roundWidth = 60;
    _isNeedToolBar = YES;
    _toolBarHeight = 50;
    _toolBar = nil;
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
    self.webView = webView;
    
    // webView的基本配置
    [webView setDelegate:self];
    [webView isOpenLoadingView:_isOpenLoadingView];
    [webView setLoadingViewStyle:_loadingStyle];
    [webView setLineWidth:_lineWidth];
    [webView setLineColor:_lineColor];
    [webView setIsAsyncLoading:_isAsync];
    [webView setRoundWidth:_roundWidth];
    [webView isNeedToolBar:_isNeedToolBar];
    [webView setToolBarForHeight:_toolBarHeight];
}

#pragma - mark      ---------- 自定义工具条 ----------
- (void)setToolBar:(UIView *)toolBar {
    _toolBar = toolBar;
    [self.webView setCustomToolBar:toolBar];
}

/**
 *  使用WebView加载URLString的形式
 */
- (void)loadURLString:(NSString *)URLString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadURL:[NSURL URLWithString:URLString]];
    });
}

/**
 *  使用WebView加载HTMLString的形式
 */
- (void)loadHTMLString:(NSString *)HTMLString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString:HTMLString];
    });
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:)]) {
        return [_delegate webView:webView shouldStartLoadWithRequest:request];
    }
    return YES;
}

/**
 *  正在加载
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)webViewDidStartLoad:(id<JGWebView>)webView {
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webViewDidStartLoad:webView];
    }
}

/**
 *  加载完成
 *
 *  @param webView webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载
 */
- (void)webViewDidFinishLoad:(id<JGWebView>)webView {
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:webView];
    }
}

/**
 *  获取当前加载的网页标题
 */
- (void)webView:(id<JGWebView>)webView getHtmlTitle:(NSString *)title {
    self.title = title;
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlTitle:)]) {
        [_delegate webView:webView getHtmlTitle:title];
    }
}

/**
 *  获取当前加载的网页内容
 */
- (void)webView:(id<JGWebView>)webView getHtmlContent:(NSString *)content {
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlContent:)]) {
        [_delegate webView:webView getHtmlContent:content];
    }
}

/**
 *  加载失败
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 *  @param error   失败的对象
 */
- (void)webView:(id<JGWebView>)webView didFailLoadWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_delegate webView:webView didFailLoadWithError:error];
    }
}

/**
 *  点击工具栏中的分享按钮
 *
 *  @param webView 正在加载的webView虚拟对象，如果需要用到webView，就用这个对象加载 getWebView 这个方法
 */
- (void)didClickToolBarForShareItemWithWebView:(id<JGWebView>)webView {
    // 分享按钮
    if (_delegate && [_delegate respondsToSelector:@selector(didClickToolBarForShareItemWithWebView:)]) {
        [_delegate didClickToolBarForShareItemWithWebView:webView];
    }
}

#pragma - mark      ---------- JGWebViewUIDelegate ----------
/**
 *  webView关闭
 *
 *  @param webView webView
 */
- (void)webViewDidClose:(id<JGWebView>)webView {
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidClose:)]) {
        [_delegate webViewDidClose:webView];
    }
}

/**
 *  用户用足够的力触摸来弹出视图控制器，此方法将被调用。此时，你可以选择在app中展示弹出的视图控制器
 *
 *  @param webView                  webView
 *  @param previewingViewController 要弹出的控制器
 */
- (void)webView:(id<JGWebView>)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
    if (_delegate && [_delegate respondsToSelector:@selector(webView:commitPreviewingViewController:)]) {
        [_delegate webView:webView commitPreviewingViewController:previewingViewController];
    }
}

@end
