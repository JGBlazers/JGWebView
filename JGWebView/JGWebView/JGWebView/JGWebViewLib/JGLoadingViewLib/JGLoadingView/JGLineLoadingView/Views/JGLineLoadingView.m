//
//  JGLineLoadingView.m
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGLineLoadingView.h"

@interface JGLineLoadingView ()

/**  LoadingView  */
@property (nonatomic, strong) UIView *loadingView;

/**  线条的高度  */
@property (nonatomic, assign) CGFloat lineWidth;

/**  线条的颜色  */
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation JGLineLoadingView

#pragma - mark      ---------- 属性 :loadingView 的懒加载 ----------
- (UIView *)loadingView {
    
    if (!_loadingView) {
        _loadingView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _lineWidth)];
        _loadingView.backgroundColor = [UIColor redColor];
    }
    return _loadingView;
}


/**
 *  初始化方法
 *
 *  @return 本类实例后的对象
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _lineColor = [UIColor redColor];
        _lineWidth = 5.0;
        
        self.userInteractionEnabled = NO;
        
        // 添加loadingView
        [self addSubview:self.loadingView];
    }
    return self;
}

/**
 *  获取LoadingView的父(跟)视图，用来添加到想要加载的视图上
 */
- (UIView *)getView {
    return self;
}

/**
 *  获取到LoadingView的实体View
 */
- (UIView *)getLoadingView {
    return self.loadingView;
}

/**
 *  设置线条的高度 默认5
 */
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    CGRect loadingViewR = self.loadingView.frame;
    loadingViewR.size.height = lineWidth;
    self.loadingView.frame = loadingViewR;
}

/**
 *  设置线条的颜色，默认红色
 */
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.loadingView.backgroundColor = lineColor;
}

/**
 *  是否是异步加载圈还是同步加载圈，同步的意思就是在加载的时候是否支持点击，反之异步就是说一遍加载可以一遍做其他的操作，比如点击其他的按钮
 *
 *  @param isAsync 是否异步  默认是异步加载
 */
- (void)setIsAsyncLoading:(BOOL)isAsync {
    self.userInteractionEnabled = !isAsync;
}

/**
 *  设置加载圈圈的大小，默认是50， line类型的加载无关
 */
- (void)setRoundWidth:(CGFloat)roundWidth {}

/**
 *  开始Loading
 */
- (void)startLoading {
    
    self.loadingView.frame = CGRectMake(0, 0, 0, _lineWidth);
    [UIView animateWithDuration:2 animations:^{
        self.loadingView.frame = CGRectMake(0, 0, self.frame.size.width * 0.8, _lineWidth);
    }];
}

/**
 *  结束loading
 */
- (void)endLoading {
    self.loadingView.frame = CGRectMake(0, 0, self.frame.size.width * 0.8, _lineWidth);
    [UIView animateWithDuration:0.4 animations:^{
        self.loadingView.frame = CGRectMake(0, 0, self.frame.size.width, _lineWidth);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
