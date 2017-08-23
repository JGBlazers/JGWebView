//
//  JGLoadingView.h
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JGLoadingView <NSObject>

/**
 *  获取LoadingView的父(跟)视图，用来添加到想要加载的视图上
 */
- (UIView *)getView;

/**
 *  获取到LoadingView的实体View
 */
- (UIView *)getLoadingView;

/**
 *  设置线条的高度 默认5
 */
- (void)setLineWidth:(CGFloat)lineWidth;

/**
 *  设置线条的颜色，默认红色
 */
- (void)setLineColor:(UIColor *)lineColor;

/**
 *  是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮
 *
 *  @param isAsync 是否异步  默认是异步加载
 */
- (void)setIsAsyncLoading:(BOOL)isAsync;

/**
 *  设置加载圈圈的大小，默认是50， line类型的加载无关
 */
- (void)setRoundWidth:(CGFloat)roundWidth;

/**
 *  开始Loading
 */
- (void)startLoading;

/**
 *  结束loading
 */
- (void)endLoading;

@end
