//
//  FRMRuntimeHelpers.h
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 22.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#import <Foundation/Foundation.h>

void MethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel);
void MethodSwizzleClass(Class aClass, SEL orig_sel, SEL alt_sel);

@interface FRMRuntimeHelpers : NSObject

@end
