//
//  JGLoadingEngine.m
//  JGLoading
//
//  Created by FCG on 2017/8/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGLoadingEngine.h"
#import "JGLineLoadingFactory.h"
#import "JGRoundLoadingFactory.h"

@interface JGLoadingEngine ()

/**  加载圈的风格  */
@property (nonatomic, assign) JGLoadingStyle style;

@end

@implementation JGLoadingEngine

#pragma - mark      ---------- 单例构造方法 ----------

static JGLoadingEngine *_instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

/**
 *  构造方法  -> 调用这个方法或者系统默认的init构造方法时，必须要将你要选择的loading的style传过来，不传就默认是Round
 */
+ (id)shareEngine {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JGLoadingEngine alloc] init];
    });
    _instance.style = JGLoadingStyleForLine;
    return _instance;
}

/**
 *  loading引擎的单例构造方法
 *
 *  @param style loading的风格
 */
+ (instancetype)shareEngineWithStyle:(JGLoadingStyle)style {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JGLoadingEngine alloc] init];
    });
    _instance.style = style;
    return _instance;
}

/**
 *  得到Loading的工厂
 */
- (id<JGLoadingFactory>)getLoadingFactory {
    
    
    id<JGLoadingFactory> factory = nil;
    switch (self.style) {
        case JGLoadingStyleForRound:
        {
            factory = [[JGRoundLoadingFactory alloc] init];
        }
            break;
        case JGLoadingStyleForLine:
        {
            factory = [[JGLineLoadingFactory alloc] init];
        }
            break;
            
        default:
            break;
    }
    return factory;
}

@end
