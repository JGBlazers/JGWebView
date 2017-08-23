//
//  JGUIWebViewController.m
//  JGWebViewDemo
//
//  Created by FCG on 2017/8/23.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
