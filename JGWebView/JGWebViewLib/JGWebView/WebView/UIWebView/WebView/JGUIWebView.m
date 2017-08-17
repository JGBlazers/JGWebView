//
//  JGUIWebView.m
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGUIWebView.h"
#import "JGWebViewToolBar.h"

@interface JGUIWebView ()<UIWebViewDelegate>

/**  webView  */
@property (nonatomic, strong) UIWebView *webView;

/**  代理对象  */
@property (nonatomic, assign) id <JGWebViewDelegate> delegate;

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

@implementation JGUIWebView

/**
 *  监控当前视图控制器的切换状态
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.webView stopLoading];
        self.webView.delegate = nil;
        self.delegate = nil;
    }
}

/**
 *  禁止当前视图控制器0点的控制
 */
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
- (instancetype)initWithFrame:(CGRect)frame {
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
        
        UIWebView *webView  = [[UIWebView alloc] init];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setMultipleTouchEnabled:YES];
        [webView setAutoresizesSubviews:YES];
        [webView setScalesPageToFit:YES];
        [webView.scrollView setAlwaysBounceVertical:YES];
        webView.scrollView.bounces = NO;
        self.webView = webView;
        [self addSubview:webView];
        
        // 创建工具条
        [self createToolBar];
    }
    return self;
}

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
        self.webView.delegate = self;
    } else {
        self.webView.delegate = nil;
    }
}

/**
 *  此代理是为了WKWebView拓展的，如果不需要或者是使用UIWebView时，可以不调用次方法
 */
- (void)setUIDelegate:(id<JGWebViewUIDelegate>)ui_delegate {}

#pragma mark -  加载链接的方式
- (void)loadRequest:(NSURLRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadRequest:request];
    });
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
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
        [self.loadingView startLoading];
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
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loadingView) {
            [self.loadingView setLineColor:lineColor];
        }
//    });
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

#pragma - mark      ---------- UIWebViewDelegate ----------
/// 将要开始加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 创建LoadingView
    [self createLoadingView];
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
    
    // 设置代理回调
    if (_delegate  && [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:)]) {
        return [_delegate webView:self shouldStartLoadWithRequest:request];
    }
    return YES;
}

/// 正在加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // 回调正在加载中的代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webViewDidStartLoad:self];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
}

/// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 回调加载完成的代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:self];
    }
    
    // 获取当前网页的标题
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlTitle:)]) {
        [_delegate webView:self getHtmlTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }
    
    // 获取当前网页的内容
    if (_delegate && [_delegate respondsToSelector:@selector(webView:getHtmlContent:)]) {
        [_delegate webView:self getHtmlContent:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"]];
    }
    
    // 加载进度条停止
    if (_loadingView) {
        [_loadingView endLoading];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
}

/// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // 回调失败的代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_delegate webView:self didFailLoadWithError:error];
    }
    
    // 加载进度条停止
    if (_loadingView) {
        [_loadingView endLoading];
    }
    
    // 配置前进的按钮是否可点击
    [self setGoForwardItem];
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
