//
//  JGUIWebViewController.m
//  JGWebView
//
//  Created by FCG on 2017/8/16.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGUIWebViewController.h"

@interface JGUIWebViewController ()

@end

@implementation JGUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView setLoadingViewStyle:JGLoadingStyleForRound];
    [self setIsNeedToolBar:NO];
}

@end
