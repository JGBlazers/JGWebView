//
//  JGWKWebView.m
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWKWebView.h"
#import "JGWebViewToolBar.h"
#import "NSHTTPCookie+JG.h"

@interface JGWKWebView()<WKNavigationDelegate, WKUIDelegate>

/**  webView  */
@property (nonatomic, strong) WKWebView *webView;

/**  cookie环境的基本配置对象  */
@property (nonatomic, strong) WKWebViewConfiguration *configuration;

/**  代理对象  */
@property (nonatomic, assign) id <JGWebViewDelegate> delegate;

/**  代理对象  */
@property (nonatomic, assign) id <JGWebViewUIDelegate> ui_delegate;

#pragma - mark      ---------- toolBar相关属性 ----------

/**  工具条  */
@property (nonatomic, strong) JGWebViewToolBar *toolBar;

/**  是否是自定义的工具条 默认不是  */
@property (nonatomic, assign) BOOL isCustomToolBar;

/**  是否需要工具条  */
@property (nonatomic, assign) BOOL isNeedToolBar;

/**  工具条的高度  */
@property (nonatomic, assign) CGFloat toolBarHeight;

/**  点击关闭时的调用的block  */
@property (nonatomic, copy) JGCloseBlock cBlock;

#pragma - mark      ---------- LoadingView相关属性 ----------
/**  loadingView  */
@property (nonatomic, weak) id <JGLoadingView> loadingView;
///创建LoadingView的引擎
@property (nonatomic, strong) JGLoadingEngine *loadingViewEngine;
///loadingView的风格 默认是线条
@property (nonatomic, assign) JGLoadingStyle loadingViewStyle;
/**  是否要打开LoadingView 默认是打开  */
@property (nonatomic, assign) BOOL isOpenLoadingView;
/// LoadingView的线条宽度 默认5
@property (nonatomic, assign) CGFloat lineWidth;
/// LoadingView的线条颜色 默认红色
@property (nonatomic, strong) UIColor *lineColor;
/// LoadingView是否异步加载 默认yes
@property (nonatomic, assign) BOOL isAsync;
/// LoadingView的圆圈的高度和官渡 默认60
@property (nonatomic, assign) CGFloat roundWidth;

@end

@implementation JGWKWebView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.webView stopLoading];
        self.webView.UIDelegate = nil;
        self.webView.navigationDelegate = nil;
        self.delegate = nil;
        self.ui_delegate = nil;
    }
}

- (void)didMoveToSuperview {
    [self viewController].automaticallyAdjustsScrollViewInsets = NO;
}

/**
 *  返回当前视图的控制器
 */
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/**
 *  初始化webView的方法
 *
 *  @param frame webView的frame
 */
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _isNeedToolBar = YES;
        _toolBarHeight = 50;
        _isCustomToolBar = NO;
        
        _loadingViewStyle = JGLoadingStyleForLine;
        _isOpenLoadingView = YES;
        _lineWidth = 5;
        _lineColor = [UIColor redColor];
        _isAsync = YES;
        _roundWidth = 60;
        
        self.configuration = [self setWebViewConfiguration];
        
        WKWebView *webView  = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setMultipleTouchEnabled:YES];
        [webView setAutoresizesSubviews:YES];
        [webView.scrollView setAlwaysBounceVertical:YES];
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        self.webView = webView;
        
        
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *userAgent = result;
            NSLog(@"navigator.userAgent == %@", userAgent);
        }];
        
        // 创建工具条
        [self createToolBar];
    }
    return self;
}

#pragma - mark      ---------- 配置cookie环境 ----------
- (WKWebViewConfiguration *)setWebViewConfiguration {
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    webConfig.preferences = [[WKPreferences alloc] init];
    // 默认为0
    webConfig.preferences.minimumFontSize = 10;
    // 默认认为YES
    webConfig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    webConfig.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
    
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    
    return webConfig;
}

/*!
 *  更新webView的cookie
 */
- (void)updateWebViewCookie
{
    NSMutableString *script = [NSMutableString string];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) continue;
        [script appendFormat:@"document.cookie='%@'; \n", cookie.da_javascriptString];
    }
    
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    //添加Cookie
    [self.configuration.userContentController addUserScript:cookieScript];
    
}

//核心方法：
/**
 修复打开链接Cookie丢失问题
 
 @param request 请求
 @return 一个fixedRequest
 */
- (NSURLRequest *)fixRequest:(NSURLRequest *)request
{
    [self updateWebViewCookie];
    
    NSMutableURLRequest *fixedRequest;
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        fixedRequest = (NSMutableURLRequest *)request;
    } else {
        fixedRequest = request.mutableCopy;
    }
    //防止Cookie丢失
    NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    if (dict.count) {
        NSMutableDictionary *mDict = request.allHTTPHeaderFields.mutableCopy;
        [mDict setValuesForKeysWithDictionary:dict];
        fixedRequest.allHTTPHeaderFields = mDict;
    }
    return fixedRequest;
}

#pragma - mark      ---------- 获取webView或者是获取到webView的父视图 ----------
/**
 *  获取到webView的父视图(跟视图)，在做添加视图的时候，一定要调用这个方法添加到想要的视图上去
 *  如[<UIView> addSubview:[外部webView的对象调用这个方法 getView]];
 */
- (UIView *)getView {
    return self;
}

/**
 *  获取实际上的webView，如果想要获取到实际上的webView，就要调用这个方法
 */
- (UIView *)getWebView {
    return self.webView;
}

#pragma - mark      ---------- 工具条相关 ----------
- (void)createToolBar {
    if (self.isNeedToolBar) {
        if (_toolBar == nil) {
            JGWebViewToolBar *toolBar = [[JGWebViewToolBar alloc] initWithFrame:CGRectZero];
            self.toolBar = toolBar;
            
            __weak __typeof(self)weakSelf = self;
            toolBar.itemClickBlock = ^(NSInteger itemTag){
                [weakSelf toolBarItemClickWithTag:itemTag];
            };
        }
        [self addSubview:_toolBar];
    }
    return;
}

/**
 *  是否需要工具条
 *
 *  @param isNeed 是否需要
 */
- (void)isNeedToolBar:(BOOL)isNeed {
    _isNeedToolBar = isNeed;
    if (isNeed) {
        [self createToolBar];
        [self layoutSubviews];
    } else {
        [self.toolBar removeFromSuperview];
        self.toolBar = nil;
    }
}

/**
 *  设置工具条的高度
 *
 *  @param height 高度
 */
- (void)setToolBarForHeight:(CGFloat)height {
    if (_toolBarHeight != height) {
        _toolBarHeight = height;
        [self layoutSubviews];
    }
}

/**
 *  自定义工具条，如果自定义了工具条，就不需要设置传高度过来，直接将自定义的toolBar对象传过来就好
 *
 *  @param toolBar 自定义的工具条
 */
- (void)setCustomToolBar:(UIView *)toolBar {
    self.isCustomToolBar = YES;
    [self.toolBar removeFromSuperview];
    self.toolBar = nil;
    [self addSubview:toolBar];
    self.toolBar = (JGWebViewToolBar *)toolBar;
    [self layoutSubviews];
}

/**
 *  工具条点击按钮的处理
 *
 *  @param tag 对应的item的tag值
 */
- (void)toolBarItemClickWithTag:(NSInteger)tag {
    switch (tag) {
        case 0: {
            [self goBack];
        }
            break;
        case 1: {
            [self goForward];
        }
            break;
        case 2: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToolBarForShareItemWithWebView:)]) {
                [self.delegate didClickToolBarForShareItemWithWebView:self];
            }
        }
            break;
        case 3: {
            [self reLoadCurrentPage];
        }
            break;
        case 4: {
            [self closeWebView];
        }
            break;
            
        default:
            break;
    }
}

#pragma - mark      ---------- 设置代理 ----------

/**
 *  设置代理
 */
- (void)setDelegate:(id<JGWebViewDelegate>)delegate {
    _delegate = delegate;
    if (_delegate) {
        self.webView.navigationDelegate = self;
    } else {
        self.webView.navigationDelegate = nil;
    }
}

/**
 *  此代理是为了WKWebView拓展的，如果不需要或者是使用UIWebView时，可以不调用次方法
 */
- (void)setUIDelegate:(id<JGWebViewUIDelegate>)ui_delegate {
    _ui_delegate = ui_delegate;
    if (_ui_delegate) {
        self.webView.UIDelegate = self;
    } else {
        self.webView.UIDelegate = nil;
    }
}

#pragma mark -  ----- 加载链接的方式 ---
- (void)loadRequest:(NSURLRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadRequest:request];
    });
}
- (void)loadURL:(NSURL *)URL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    //Cookies数组转换为requestHeaderFields
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //设置请求头
    request.allHTTPHeaderFields = requestHeaderFields;
    [self loadRequest:request];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString:HTMLString baseURL:nil];
    });
}

#pragma - mark      ---------- 控制WebView的基本方法 ----------

/**
 *  返回上一页
 */
- (void)goBack {
    // 如果可以返回，那点击了就可以返回，如果不可以，一般情况都直接返回到上个控制器的界面，具体自己决定
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        //NSLog(@"如果可以返回，那点击了就可以返回，如果不可以，一般情况都直接返回到上个控制器的界面，具体自己决定");
        [self closeWebView];
    }
}

/**
 *  前往下一页
 */
- (void)goForward {
    if ([self.webView canGoForward]) [self.webView goForward];
}

/**
 *  刷新当前页
 */
- (void)reLoadCurrentPage {
    [self.webView reload];
}

- (void)closeWebView {
    if (self.cBlock) {
        self.cBlock();
    } else {
        UIViewController *currentVC = [self viewController];
        if ([currentVC isKindOfClass:[UINavigationController class]] || currentVC.navigationController != nil) {
            [currentVC.navigationController popViewControllerAnimated:YES];
        } else {
            [currentVC dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

/**
 *  关闭webView，如果不实现的情况下，默认是优先pop出栈，pop不行就考虑dismis下模态
 */
- (void)closeWebViewWithCloseBlock:(JGCloseBlock)cBlock {
    self.cBlock = cBlock;
}

/**
 *  配置前进的按钮是否可点击
 */
- (void)setGoForwardItem {
    
    if (_isNeedToolBar && !_isCustomToolBar) {
        [self.toolBar setIsGoNext:[self.webView canGoForward]];
    }
}

#pragma - mark      ---------- JGLoadingView ----------
/**
 *  创建LoadingView
 */
- (void)createLoadingView {
    
    // 加载进度条停止   这里加上是为了某些网站第一时间连续性刷新太多URL，导致loadingView重叠
    if (_loadingView) {
        [_loadingView endLoading];
    }
    
    // 如果不需要打开Loading的情况下，直接返回
    if (!_isOpenLoadingView) {
        return;
    }
    
    // 创建LoadingView的引擎
    JGLoadingEngine *loadingViewEngine = [JGLoadingEngine shareEngineWithStyle:_loadingViewStyle];
    self.loadingViewEngine = loadingViewEngine;
    
    // 创建工厂
    id <JGLoadingFactory> factory = [loadingViewEngine getLoadingFactory];
    // 创建LoadingView的虚拟对象
    id <JGLoadingView> loadingView = [factory getLoadingViewWithFrame:self.webView.frame];
    // 将loadingView的父视图添加
    [self addSubview:[loadingView getView]];
    
    // LoadingView的基本配置
    [loadingView setLineColor:_lineColor];
    [loadingView setLineWidth:_lineWidth];
    [loadingView setIsAsyncLoading:_isAsync];
    [loadingView setRoundWidth:_roundWidth];
    
    self.loadingView = loadingView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 开始加载
        [loadingView startLoading];
    });
}

/**
 *  设置LoadingView的风格
 */
- (void)setLoadingViewStyle:(JGLoadingStyle)style {
    _loadingViewStyle = style;
    if (self.loadingView) {
        [self.loadingView endLoading];
        [self createLoadingView];
    }
}

/**
 *  是否要使用附带的loadingView
 */
- (void)isOpenLoadingView:(BOOL)isOpenLoadingView {
    _isOpenLoadingView = isOpenLoadingView;
    if (self.loadingView) {
        [self.loadingView endLoading];
    }
}

/**
 *  设置线条的高度 默认5
 */
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    if (self.loadingView) {
        [self.loadingView setLineWidth:lineWidth];
    }
}

/**
 *  设置线条的颜色，默认红色
 */
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    if (self.loadingView) {
        [self.loadingView setLineColor:lineColor];
    }
}

/**
 *  是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮
 *
 *  @param isAsync 是否异步  默认是异步加载
 */
- (void)setIsAsyncLoading:(BOOL)isAsync {
    _isAsync = isAsync;
    if (self.loadingView) {
        [self.loadingView setIsAsyncLoading:isAsync];
    }
}

/**
 *  设置加载圈圈的大小，默认是50， line类型的加载无关
 */
- (void)setRoundWidth:(CGFloat)roundWidth {
    _roundWidth = roundWidth;
    if (self.loadingView) {
        [self.loadingView setRoundWidth:roundWidth];
    }
}

#pragma - mark      ---------- WKNavigationDelegate ----------
// 加载之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    // 创建LoadingView
    [self createLoadingView];
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
    
    //解决Cookie丢失问题
    NSURLRequest *originalRequest = navigationAction.request;
    [self fixRequest:originalRequest];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:)]) {
        if ([self.delegate webView:self shouldStartLoadWithRequest:navigationAction.request]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            //允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
            webView.UIDelegate = nil;
            webView.navigationDelegate = nil;
            return;
        };
    } else {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 加载中
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    // 回调加载完成的代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:self];
    }
    
    // 获取当前网页的标题
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlTitle:)]) {
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            if (!error) [_delegate webView:self getHtmlTitle:htmlStr];
            else NSLog(@"JSError:%@",error);
        }] ;
    }
    
    // 获取当前网页的内容
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlContent:)]) {
        [webView evaluateJavaScript:@"document.getElementsByTagName('html')[0].innerHTML" completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            if (!error) [_delegate webView:self getHtmlContent:htmlStr];
            else NSLog(@"JSError:%@",error);
        }];
    }
    
    // 加载进度条停止
    if (_loadingView) {
        [_loadingView endLoading];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
    
    // 加载进度条停止
    if (_loadingView) {
        [_loadingView endLoading];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
}

#pragma - mark      ---------- WKUIDelegate ----------

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    //这里不打开新窗口
    [self.webView loadRequest:[self fixRequest:navigationAction.request]];
    return nil;
}

/**
 *  WKWebView关闭的时候调用
 */
- (void)webViewDidClose:(WKWebView *)webView {
    if (self.ui_delegate && [self.ui_delegate respondsToSelector:@selector(webViewDidClose:)]) {
        [self.ui_delegate webViewDidClose:self];
    }
}

/**
 *  用户用足够的力触摸来弹出视图控制器，此方法将被调用。此时，你可以选择在app中展示弹出的视图控制器
 *
 *  @param webView                  webView
 *  @param previewingViewController 要弹出的控制器
 */
- (void)webView:(id<JGWebView>)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
    if (self.ui_delegate && [self.ui_delegate respondsToSelector:@selector(webView:commitPreviewingViewController:)]) {
        [self.ui_delegate webView:self commitPreviewingViewController:previewingViewController];
    }
}

#pragma - mark      ---------- 控件排列 ----------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize selfSize = self.frame.size;
    
    CGFloat toolBarHeight = self.toolBarHeight;
    if (self.isCustomToolBar) {
        toolBarHeight = self.toolBar.frame.size.height;
    } else {
        if (_isNeedToolBar == NO) {
            toolBarHeight = 0.000001;
        }
    }
    
    self.webView.frame = CGRectMake(0, 0, selfSize.width, selfSize.height - toolBarHeight);
    
    if (self.toolBar) {
        self.toolBar.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame), selfSize.width, toolBarHeight);
    }
}

@end
