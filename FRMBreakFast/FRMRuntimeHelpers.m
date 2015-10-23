//
//  FRMRuntimeHelpers.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 22.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#import "FRMRuntimeHelpers.h"
#import <objc/runtime.h>

void MethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel)
{
    Method orig_method = nil, alt_method = nil;
    
    // First, look for the methods
    orig_method = class_getInstanceMethod(aClass, orig_sel);
    alt_method = class_getInstanceMethod(aClass, alt_sel);
    
    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
        method_exchangeImplementations(orig_method, alt_method);
    }
    else {
        NSLog(@"FRMBreakFast: Could not swizzle %@ - %@", NSStringFromClass(aClass), NSStringFromSelector(orig_sel));
    }
}

void MethodSwizzleClass(Class aClass, SEL orig_sel, SEL alt_sel)
{
    Method orig_method = nil, alt_method = nil;
    
    // First, look for the methods
    orig_method = class_getClassMethod(aClass, orig_sel);
    alt_method = class_getClassMethod(aClass, alt_sel);
    
    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
        method_exchangeImplementations(orig_method, alt_method);
    }
    else {
        NSLog(@"FRMBreakFast: Could not swizzle %@ + %@", NSStringFromClass(aClass), NSStringFromSelector(orig_sel));
    }
}


@implementation FRMRuntimeHelpers

@end
