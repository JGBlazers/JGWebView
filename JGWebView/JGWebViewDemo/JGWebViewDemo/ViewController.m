//
//  ViewController.m
//  JGWebViewDemo
//
//  Created by FCG on 2017/8/23.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "ViewController.h"
// 测试WKWebView
#import "JGWKWebViewController.h"
// 测试UIWebView
#import "JGUIWebViewController.h"
// 测试自定义toolBar
#import "JGCustomToolBarVC.h"
// JGWebView最基础的使用
#import "JGWebViewNormalUseVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, JGWebVCDelegate>

/**  功能数组  */
@property (nonatomic, strong) NSArray *menusArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JGWebView测试";
    
    _menusArray = @[
                    @"UIWebView测试",
                    @"WKWebView测试",
                    @"自定义toolBar测试",
                    @"JGWebView的最基础使用",
                    ];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma - mark -    UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _menusArray[indexPath.row];
    
    return cell;
}

#pragma - mark -    UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            JGUIWebViewController *ui_webVC = [[JGUIWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForUIWebView];
            [ui_webVC loadURLString:@"https://www.baidu.com"];
            [self.navigationController pushViewController:ui_webVC animated:YES];
        }
            break;
        case 1:
        {
            JGWKWebViewController *wk_webVC = [[JGWKWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForWKWebView];
            [wk_webVC loadURLString:@"https://www.baidu.com"];
            [self.navigationController pushViewController:wk_webVC animated:YES];
        }
            break;
        case 2:
        {
            JGCustomToolBarVC *cst_toolBarVC = [[JGCustomToolBarVC alloc] initWithWebViewEngineWithType:JGWebViewTypeForWKWebView];
            [cst_toolBarVC loadURLString:@"https://www.baidu.com"];
            [self.navigationController pushViewController:cst_toolBarVC animated:YES];
        }
            break;
        case 3:
        {
            JGWebViewNormalUseVC *normalUseVC = [[JGWebViewNormalUseVC alloc] init];
            [self.navigationController pushViewController:normalUseVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    /* 如果不想开类，完全可以使用下面的方式进行操作，代理方法也可以直接写在这个类中
     JGWebViewController *ui_webVC = [[JGWebViewController alloc] initWithWebViewEngineWithType:JGWebViewTypeForUIWebView];
     [ui_webVC loadURLString:@"https:www.baidu.com"];
     ui_webVC.delegate = self;
     [self.navigationController pushViewController:ui_webVC animated:YES];
     */
}

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

@end
