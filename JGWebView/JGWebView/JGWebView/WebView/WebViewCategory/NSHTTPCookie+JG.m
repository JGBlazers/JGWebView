//
//  NSHTTPCookie+JG.m
//  JGWebView
//
//  Created by FCG on 2017/8/16.
//  Copyright © 2017年 FCG. All rights reserved.
//

#import "NSHTTPCookie+JG.h"

@implementation NSHTTPCookie (JG)

- (NSString *)da_javascriptString {
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    return string;
}

@end
