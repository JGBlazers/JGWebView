//
//  JGWebViewFactory.h
//  JGWebView
//
//  Created by FCG on 2017/8/4.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGWebView.h"

@protocol JGWebViewFactory <NSObject>

/**
 *  创建WebView
 *
 *  @param frame webView的大小
 */
- (id<JGWebView>)getWebViewWithFrame:(CGRect)frame;

@end
