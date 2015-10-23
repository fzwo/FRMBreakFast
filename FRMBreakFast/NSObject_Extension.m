//
//  NSObject_Extension.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 21.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//


#import "NSObject_Extension.h"
#import "FRMBreakFast.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[FRMBreakFast alloc] initWithBundle:plugin];
        });
    }
}
@end
