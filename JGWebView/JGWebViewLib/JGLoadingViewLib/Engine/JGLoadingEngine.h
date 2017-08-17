//
//  JGLoadingEngine.h
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGLoadingFactory.h"

typedef enum {
    JGLoadingStyleForLine,      // 一条线的Loading, 默认
    JGLoadingStyleForRound,     // 圆形转圈的Loading
} JGLoadingStyle;

@interface JGLoadingEngine : NSObject

/**
 *  构造方法  -> 调用这个方法或者系统默认的init构造方法时，必须要将你要选择的loading的style传过来，不传就默认是Round
 */
+ (id)shareEngine;

/**
 *  loading引擎的单例构造方法 默认 JGLoadingStyleForLine
 *
 *  @param style loading的风格
 */
+ (instancetype)shareEngineWithStyle:(JGLoadingStyle)style;

/**
 *  得到Loading的工厂
 */
- (id<JGLoadingFactory>)getLoadingFactory;

@end
