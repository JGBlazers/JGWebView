# ☆☆☆ JGWebView ☆☆☆
***
#### 预览图：
![预览图](https://github.com/fcgIsPioneer/iOS_Demo_Gif_manager/blob/master/JGWebView/JGWebView.gif)
***
#### JGWebView功能介绍：
* **基本功能** ：在系统WKWebView、UIWebView的基础上进行封装
* **加载方式** ：为了提高体验，在框架中集成了同样以工厂模式封装的JGLoadingView
* **工 具 条** ：仿现在主流浏览器的底部工具栏的基础功能，默认提供了可基本操作的工具栏，包含了后退、前进、刷新、退出、分享(分享功能具体已开启出了入口，具体分享内容需要自己实现)等
*  **拓展基类** ：以JGWebView为基础，拓展JGWebViewController的web页加载控制器基类，如果在跳转到下个界面做加载的情况下，建议直接集成这个基类，或者直接拿这个基类做创建就好，相关代理方法也做了提供，即使类型普通创建UI那样创建，也可以通过提供的代理方法监听相关webView的加载事件
* **设计模式** ：以虚拟工厂模式作为基础框架进行设计，达到解耦、一键切换的效果、
* **cookie同步** : 在JGWebView中，根据webView的cookie机制，做了cookie的简单配置

#### JGWebView 的集成
* **CocoaPods方式集成 (推荐使用此方式)** : 在pod创建时的Podfile文件中，添加上pod 'JGWebView'，然后在终端切换到项目根目录下，执行命令**pod update**，接着执行**pod install**即可
*  **手动集成**: 打开地址[https://github.com/fcgIsPioneer/JGWebView.git](https://github.com/fcgIsPioneer/JGWebView.git)下载或者克隆下来之后，将JGWebView这个包含着(JGLoadingViewLib、JGWebView、JGWebViewCongroller)的文件夹，拖到项目中即可

[TOC]
#### JGWebView的基本使用
##### ☆ 使用方式一：如果在当场使用的情况下，可以直接按照下面的方式进行创建
```objectivec
// 初始化引擎
JGWebViewEngine *engine = [JGWebViewEngine shareWebViewEngineWithType:JGWebViewTypeForUIWebView];
// 获取webView的工厂
id <JGWebViewFactory> factory = [engine getWebViewFactory];
// 拿到webView虚拟对象
id <JGWebView> webView = [factory getWebViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
// webView的代理
[webView setDelegate:self];
// 通过webView的虚拟对象，将webView添加到self.view上
[self.view addSubview:[webView getView]];

// 加载
[webView loadURLString:@"https://www.baidu.com"];
```
> 在直接使用JGWebView的时候，+shareWebViewEngineWithType: 最好直接使用这个方法进行初始化webView的引擎，这样会很直观的去决定使用的是UIWebViewh还是WKWebView，如果非此方法创建的JGWebView，都会直接默认创建的是UIWebView

##### ☆ 使用方式二：如果需要跳转到下一个界面加载URL的情况下，建议使用类库中提供的JGWebViewController为基类创建要加载的下一级控制器，创建方式有以下两种方式：
- **最简单的使用方式，就是直接在需要的地方，创建基类对象，传入URL字符串即可，主要代码如下所示：**
``` objectivec 
// 如果不想开类，完全可以使用下面的方式进行操作，代理方法也可以直接写在这个类中
JGWebViewController *webVC = [[JGWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForUIWebView];
[ui_webVC loadURLString:@"https:www.baidu.com"];
// 如果需要监听代理，也可以直接将JGWebViewController所提供的代理方法拉到使用JGWebViewController的当前类去实现
webVC.delegate = self;
[self.navigationController pushViewController:webVC animated:YES];
```

- **另一种做法为以JGWebViewController为基(父类)，创建JGWebViewController的子类，继承了父类的属性和方法，只需要在父类的-ViewDidLoad 方法中加载URL即可，也可以在外部创建的时候，调用-loadURLString:或者-loadHTMLString:就可以了，主要代码如下所示：**
``` objectivec 
#pragma mark ---- 创建

// 在webVC入口的地方，创建JGWebViewController的子类，主要代码如下：
JGUIWebViewController *webVC = [[JGUIWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForUIWebView];
// 如果这里不做URL加载，也可以在子类中进行加载
[webVC loadURLString:@"https://www.baidu.com"];
[self.navigationController pushViewController:webVC animated:YES];

#pragma mark ---- 子类中具体实现
- (void)viewDidLoad {
[super viewDidLoad];
// 加载URL
[self loadURLString:@"https://www.baidu.com"];
}
```
> * 在基类的使用中，提供了构造方法-initWithWebViewEngineWithType: ，在构造时决定了JGWebView的加载方式
> * 使用基类的方式中，第一种使用较为简便，第二种方式，是为了在基类不满足个人需要的情况下，拓展自己的功能效果

****
#### JGWebView详解
☆  **代理方法**：在JGWebView中，提供了基本(平常使用)代理方法***WebViewDelegate***根据个人需要拓展的代理方法***JGWebViewUIDelegate***，如果不满足现有需要，可以参考原有的代理方法的实现方式进行拓展
##### ☆ <a id="WebViewDelegate.h"></a>WebViewDelegate.h
```objectivec
/// 将要开始加载
- (BOOL)webView:(id<JGWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request;
/// 正在加载
- (void)webViewDidStartLoad:(id<JGWebView>)webView;

/// 加载完成
- (void)webViewDidFinishLoad:(id<JGWebView>)webView;

/// 获取当前加载的网页标题
- (void)webView:(id<JGWebView>)webView getHtmlTitle:(NSString *)title;

/// 获取当前加载的网页内容
- (void)webView:(id<JGWebView>)webView getHtmlContent:(NSString *)content;

/// 加载失败
- (void)webView:(id<JGWebView>)webView didFailLoadWithError:(NSError *)error;

/// 点击工具栏中的分享按钮
- (void)didClickToolBarForShareItemWithWebView:(id<JGWebView>)webView;
```
##### ☆ <a id="JGWebViewUIDelegate.h"></a>JGWebViewUIDelegate.h
```objectivec
/// webView关闭
- (void)webViewDidClose:(id<JGWebView>)webView;

/// 用户用足够的力触摸来弹出视图控制器，此方法将被调用。此时，你可以选择在app中展示弹出的视图控制器
- (void)webView:(id<JGWebView>)webView commitPreviewingViewController:(UIViewController *)previewingViewController;

// ---------> 还有很多代理方法，按照需要拓展 ......
```
>在每个代理方法中，都返回了JGWebView这个虚拟的webView对象，方便在使用的过程中直接使用，比如如果需要拿到具体的webView，通过***[webView getWebView];*** 的方式进行获取

☆  **相关属性详解**：在JGWebView的使用过程中，提供了很多外部配置方法，可以根据需要进行相关配置
##### ☆ <a id="JGWebView.h"></a>JGWebView.h
> 在对JGWebView的相关配置中，都集中在JGWebView这个类中，具体可以查看相关实现过程
###### 在初始化时，提供实体的webView和webView的父视图进行获取
```objectivec

/// 获取到webView的父视图(跟视图)，在做添加视图的时候，一定要调用这个方法添加到想要的视，如[<UIView> addSubview:[外部webView的对象调用这个方法 getView]];
- (UIView *)getView;
/// 获取实际上的webView，如果想要获取到实际上的webView，就要调用这个方法
- (UIView *)getWebView;
/// 设置代理，设置了之后代理方法就会调用，不设置代理的情况下，也不会加载代理方法
- (void)setDelegate:(id<JGWebViewDelegate>)delegate;
/// 此代理是为了WKWebView拓展的，如果不需要或者是使用UIWebView时，可以不调用次方法
- (void)setUIDelegate:(id<JGWebViewUIDelegate>)ui_delegate;
```
###### JGWebView加载方式和控制webView的操作
```objectivec
/// 使用WebView加载NSURLRequest的形式
- (void)loadRequest:(NSURLRequest *)request;
/// 使用WebView加载URL的形式
- (void)loadURL:(NSURL *)URL;
/// 使用WebView加载URLString的形式
- (void)loadURLString:(NSString *)URLString;
/// 使用WebView加载HTMLString的形式
- (void)loadHTMLString:(NSString *)HTMLString;
/// 返回上一页
- (void)goBack;
/// 前往下一页
- (void)goForward;
/// 刷新当前页
- (void)reLoadCurrentPage;
/// 关闭webView，如果不实现的情况下，默认是优先pop出栈，pop不行就考虑dismis下模态
- (void)closeWebViewWithCloseBlock:(JGCloseBlock)cBlock;
```
###### 对原有附带的工具栏的相关配置
```objectivec
/// 是否需要工具条 默认是YES，带工具条的
- (void)isNeedToolBar:(BOOL)isNeed;
///设置工具条的高度  默认60
- (void)setToolBarForHeight:(CGFloat)height;
/// 自定义工具条，如果自定义了工具条，一定要设置bounds
- (void)setCustomToolBar:(UIView *)toolBar;
```
###### 对原有附带的JGloadingView的相关配置
```objectivec
/// 是否要使用附带的loadingView  如果设置了这个属性后，下面loadingView的基本配置的方法就不需要管了
- (void)isOpenLoadingView:(BOOL)isOpenLoadingView;
/// 设置LoadingView的风格
- (void)setLoadingViewStyle:(JGLoadingStyle)style;
///设置线条的高度 默认5
- (void)setLineWidth:(CGFloat)lineWidth;
/// 设置线条的颜色，默认红色
- (void)setLineColor:(UIColor *)lineColor;
/// 是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮
- (void)setIsAsyncLoading:(BOOL)isAsync;
/// 设置加载圈圈的大小，默认是50， line类型的加载无关
- (void)setRoundWidth:(CGFloat)roundWidth;
```
####  注意：
>  **JGLoadingView**：
>  1、是内部封装的，也向外部提供了很多相关的自定义方法，如果不想要或者是不使用可以直接调用关闭的方法进行关闭、移除；
> 2、目前暂时不提供外部直接将自定义的JGLoadingView套到JGWebView中，所以如果是自己的自定义loading，可以根据内部的JGLoadingView的集成使用方式进行集成；
> 3、虽然JGLoadingView是集成到JGWebView中，但是相对来说也是可以独立使用的，这里就不提具体的单独使用方式，详细自己去阅读demo即可。
> **********
> **JGWebViewToolBar**：
> 1、内部附带封装的，同时提供很多JGWebViewToolBar的方法给外部相关配置，具体详细阅读JGWebView即可，如果不需要的情况下，请调用关闭的方法关闭工具栏；
> 2、支持自定义，只要将你自定义的toolBar套到JGWebView的**-setCustomToolBar:**方法里面，就可以完全实现自定义了，不过具体的控制过程，参照demo中的**JGCustomToolBarVC**这个类。

####  总结：
> 1、小弟初习虚拟工厂模式，很多地方没有把握好，据了解、目前webView的例子应用很广，所以根据目前自习的效果，详细设计了一套在系统WKWebView和UIWebView的基础上集成的一套无偶的JGWebView提供大家参考和使用
> 2、代码中提供了详细的中文注释，方便大家理解。
> 3、在使用的过程中，如果发现了问题，或者有更好的功能拓展、想法可以直接发邮件到2044471447@qq.com，本人会第一时间给予回复。
