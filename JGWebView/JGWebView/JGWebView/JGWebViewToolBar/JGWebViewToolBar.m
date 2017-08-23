//
//  JGWebViewToolBar.m
//  JGWebView
//
//  Created by FCG on 2017/8/11.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "JGWebViewToolBar.h"

@interface JGWebViewToolBar()

/**  默认图片数组  */
@property (nonatomic, strong) NSArray *imageNormalNames;

/**  高亮图片数组  */
@property (nonatomic, strong) NSArray *imageHighlightNames;

/**  后退按钮  */
@property (nonatomic, strong) UIButton *goBackBtn;

/**  前进按钮  */
@property (nonatomic, strong) UIButton *goNextBtn;

@end

@implementation JGWebViewToolBar

/**
 *  初始化方法
 *
 *  @return 本类实例后的对象
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:(245 / 255.0) green:(245 / 255.0) blue:(245 / 255.0) alpha:1];
        
        
        NSString *resourcesBundle = [[NSBundle mainBundle] pathForResource:@"JGWebViewResources.bundle" ofType:nil];
        
        // 默认图片数组
        self.imageNormalNames = @[@"webview_goback_normal_icon@2x",
                                  @"webview_goNext_normal_icon@2x",
                                  @"webview_share_icon@2x",
                                  @"webview_reload_icon@2x",
                                  @"webview_close_icon@2x"];
        // 高亮图片数组
        self.imageHighlightNames = @[@"webview_goback_highlighted_icon@2x",
                                     @"webview_goNext_highlighted_icon@2x",
                                     @"webview_share_icon@2x",
                                     @"webview_reload_icon@2x",
                                     @"webview_close_icon@2x"];
        
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.imageNormalNames.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[self getBundlePath:resourcesBundle inDirectory:@"JGWebViewToolBar" imageName:self.imageNormalNames[i]] forState:UIControlStateNormal];
            
            if (i < 2) {
                
                [btn setImage:[self getBundlePath:resourcesBundle inDirectory:@"JGWebViewToolBar" imageName:self.imageHighlightNames[i]] forState:UIControlStateSelected];
                
                [btn setImage:[self getBundlePath:resourcesBundle inDirectory:@"JGWebViewToolBar" imageName:self.imageNormalNames[i]] forState:UIControlStateHighlighted];
                if (i == 0) {
                    self.goBackBtn = btn;
                    self.goBackBtn.selected = YES;
                } else {
                    btn.selected = NO;
                    self.goNextBtn = btn;
                }
            }
            [btn sizeToFit];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [itemArray addObject:[[UIBarButtonItem alloc] initWithCustomView:btn]];
            [itemArray addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
            [self addSubview:btn];
        }
        
        [itemArray removeLastObject];
        self.items = itemArray;
        
    }
    return self;
}

/**
 *  是否可以前往上一页
 */
- (void)setIsGoNext:(BOOL)isGoNext {
    self.goNextBtn.selected = isGoNext;
}

/**
 *  读取工程目录下.Bundle文件夹的图片
 *
 *  @param bundlePath  .Bundle文件夹的目录
 *  @param inDirectory 在.Bundle文件夹下的图片所在文件夹路径
 *  @param imageName   图片名
 *
 *  @return 图片对象
 */
- (UIImage *)getBundlePath:(NSString *)bundlePath inDirectory:(NSString *)inDirectory imageName:(NSString *)imageName {
    // 找到对应images夹下的图片
    NSString *imagePath = [[NSBundle bundleWithPath:bundlePath] pathForResource:imageName ofType:@"png" inDirectory:inDirectory];
    return [UIImage imageWithContentsOfFile:imagePath];
}

#pragma - mark      ---------- 按钮的点击事件 ----------
- (void)btnClick:(UIButton *)btn {
    if (self.itemClickBlock) {
        self.itemClickBlock(btn.tag);
    }
}

@end
