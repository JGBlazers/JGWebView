//
//  JGCustomToolBarVC.m
//  JGWebView
//
//  Created by FCG on 2017/8/17.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGCustomToolBarVC.h"
// 就随便用附带的这个toolBar来做自定义的颜色
#import "JGWebViewToolBar.h"

@interface JGCustomToolBarVC ()

/**  自定义的toolBar  */
@property (nonatomic, strong) JGWebViewToolBar *customToolBar;

@end

@implementation JGCustomToolBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _customToolBar = [[JGWebViewToolBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    self.toolBar = _customToolBar;
    
    __weak __typeof(self)weakSelf = self;
    _customToolBar.itemClickBlock = ^(NSInteger itemTag){
        [weakSelf toolBarItemClickWithTag:itemTag];
    };
}

/**
 *  工具条点击按钮的处理
 *
 *  @param tag 对应的item的tag值
 */
- (void)toolBarItemClickWithTag:(NSInteger)tag {
    switch (tag) {
        case 0: {
            [self.webView goBack];
        }
            break;
        case 1: {
            [self.webView goForward];
        }
            break;
        case 2: {
            NSLog(@"这里分享按钮");
        }
            break;
        case 3: {
            [self.webView reLoadCurrentPage];
        }
            break;
        case 4: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
