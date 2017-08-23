//
//  JGWebViewToolBar.h
//  JGWebView
//
//  Created by FCG on 2017/8/11.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGWebViewToolBar : UIToolbar

/**  点击工具调的item调用  */
@property (nonatomic, strong) void(^itemClickBlock)(NSInteger itemTag);

/**
 *  是否可以前往上一页
 */
- (void)setIsGoNext:(BOOL)isGoNext;

@end
