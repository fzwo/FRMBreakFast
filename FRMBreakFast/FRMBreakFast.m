//
//  FRMBreakFast.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 21.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#import "FRMBreakFast.h"

@interface FRMBreakFast()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation FRMBreakFast

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
