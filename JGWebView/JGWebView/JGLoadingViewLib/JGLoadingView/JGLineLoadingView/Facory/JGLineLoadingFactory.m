//
//  JGLineLoadingFactory.m
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGLineLoadingFactory.h"
#import "JGLineLoadingView.h"

@implementation JGLineLoadingFactory

/**
 *  拿到LoadingView的虚拟工厂
 *
 *  @param frame LoadingView的frame，注意，如果是单线进度的情况下，进入一定会在顶部，如果是圆圈线条加载，线条会在中间
 */
- (id<JGLoadingView>)getLoadingViewWithFrame:(CGRect)frame {
    return [[JGLineLoadingView alloc] initWithFrame:frame];
}

@end
