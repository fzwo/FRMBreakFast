//
//  FRMBreakFast.h
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 21.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#import <AppKit/AppKit.h>

@class FRMBreakFast;

static FRMBreakFast *sharedPlugin;

@interface FRMBreakFast : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end