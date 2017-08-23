//
//  UIWebView+JG.m
//  JGWebView
//
//  Created by FCG on 2017/8/16.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "UIWebView+JG.h"
#import <objc/runtime.h>

@implementation UIWebView (JG)

// 因为在鼠标点击和滑动webView的时候，会产生和touch事件的冲突，所以加上这句
+ (void)load{
    //  "v@:"
    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
    class_addMethod(class, @selector(setBeingRemoved), setBeingRemoved, "v@:");
    class_addMethod(class, @selector(willBeRemoved), willBeRemoved, "v@:");
    
    class_addMethod(class, @selector(removeFromSuperview), willBeRemoved, "v@:");
}

id setBeingRemoved(id self, SEL selector, ...)
{
    return nil;
}

id willBeRemoved(id self, SEL selector, ...)
{
    return nil;
}

@end
