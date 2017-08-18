#☆☆☆ JGWebView ☆☆☆
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

#### JGWebView的基本使用
##### ※ 使用方式一：如果在当场使用的情况下，可以直接按照下面的方式进行创建
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

##### ※ 使用方式二：如果需要跳转到下一个界面加载URL的情况下，建议使用类库中提供的JGWebViewController为基类创建要加载的下一级控制器，创建方式有以下两种方式：
- **最简单的使用方式，就是直接在需要的地方，创建基类对象，传入URL字符串即可，主要代码如下所示：**
``` objectivec 
// 如果不想开类，完全可以使用下面的方式进行操作，代理方法也可以直接写在这个类中
JGWebViewController *webVC = [[JGWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForUIWebView];
[ui_webVC loadURLString:@"https:www.baidu.com"];
// 如果需要监听代理，也可以直接将JGWebViewController所提供的代理方法拉到使用JGWebViewController的当前类去实现
webVC.delegate = self;
[self.navigationController pushViewController:webVC animated:YES];
```

