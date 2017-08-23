//
//  JGRoundLoadingView.m
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGRoundLoadingView.h"

@interface JGRoundLoadingView ()

/**  LoadingView  */
@property (nonatomic, strong) UIView *loadingView;

/**  进度条图层  */
@property (nonatomic, strong) CAShapeLayer *loadingViewLayer;

/**  线条的高度  */
@property (nonatomic, assign) CGFloat lineWidth;

/**  线条的颜色  */
@property (nonatomic, strong) UIColor *lineColor;

/**  加载圈圈的高度和宽度  */
@property (nonatomic, assign) CGFloat roundWidth;

@end

@implementation JGRoundLoadingView

#pragma - mark      ---------- 属性 :loadingView 的懒加载 ----------
- (UIView *)loadingView {
    
    if (!_loadingView) {
        _loadingView  = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - _roundWidth / 2, self.frame.size.height / 2 - _roundWidth / 2, _roundWidth, _roundWidth)];
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
        _roundWidth = 60;
        
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
    self.loadingViewLayer.lineWidth = self.lineWidth;
}

/**
 *  设置线条的颜色，默认红色
 */
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.loadingViewLayer.strokeColor = lineColor.CGColor;
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
- (void)setRoundWidth:(CGFloat)roundWidth {
    _roundWidth = roundWidth;
    self.loadingView.frame = CGRectMake(self.frame.size.width / 2 - _roundWidth / 2, self.frame.size.height / 2 - _roundWidth / 2, _roundWidth, _roundWidth);
    [self.loadingViewLayer removeFromSuperlayer];
    [self startLoading];
}

/**
 *  开始Loading
 */
- (void)startLoading {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //外层旋转动画
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @0.0;
        rotationAnimation.toValue = @(2*M_PI);
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.duration = 3.0;
        rotationAnimation.beginTime = 0.0;
        
        [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        //内层进度条动画
        CABasicAnimation *strokeAnim1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnim1.fromValue = @0.0;
        strokeAnim1.toValue = @1.0;
        strokeAnim1.duration = 1.0;
        strokeAnim1.beginTime = 0.0;
        strokeAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        //内层进度条动画
        CABasicAnimation *strokeAnim2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeAnim2.fromValue = @0.0;
        strokeAnim2.toValue = @1.0;
        strokeAnim2.duration = 1.0;
        strokeAnim2.beginTime = 1.0;
        strokeAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.duration = 2.0;
        animGroup.repeatCount = HUGE_VALF;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.animations = @[strokeAnim1, strokeAnim2];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_lineWidth / 2, _lineWidth / 2, _roundWidth - _lineWidth, _roundWidth - _lineWidth)];
        
        self.loadingViewLayer = [CAShapeLayer layer];
        self.loadingViewLayer.lineWidth = self.lineWidth;
        self.loadingViewLayer.lineCap = kCALineCapRound;
        self.loadingViewLayer.strokeColor = self.lineColor.CGColor;
        self.loadingViewLayer.fillColor = [UIColor clearColor].CGColor;
        self.loadingViewLayer.strokeStart = 0.0;
        self.loadingViewLayer.strokeEnd = 1.0;
        self.loadingViewLayer.path = path.CGPath;
        [self.loadingViewLayer addAnimation:animGroup forKey:@"strokeAnim"];
        
        [self.loadingView.layer addSublayer:self.loadingViewLayer];
    });
}

/**
 *  结束loading
 */
- (void)endLoading {
    [self.loadingViewLayer removeFromSuperlayer];
    [self removeFromSuperview];
}

@end
