//
//  DBGBreakpointButton+FRMBreakFastAdditions.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 01.05.16.
//  Copyright © 2016 Friedrich Markgraf. All rights reserved.
//

#import "DBGBreakpointButton+FRMBreakFastAdditions.h"
#import "FRMRuntimeHelpers.h"
#import "IDEBreakpointIcon+FRMBreakFastAdditions.h"
#import <objc/runtime.h>

@implementation DBGBreakpointButton (FRMBreakFastAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MethodSwizzle(self,
                      @selector(initWithBreakpointIcon:),
                      @selector(init_frm_WithBreakpointIcon:));
        MethodSwizzle(self,
                      @selector(_updateImage),
                      @selector(frm_updateImage));
    });
}


- (id)init_frm_WithBreakpointIcon:(IDEBreakpointIcon *)breakpointIcon
{
    self = [self init_frm_WithBreakpointIcon:breakpointIcon];
    
    return self;
}


- (void)frm_updateImage
{
    IDEBreakpoint *breakpoint = self.breakpoint;

    IDEBreakpointIcon *icon = [[IDEBreakpointIcon alloc] init_frm_WithSize:self.intrinsicContentSize
                                                       breakpointContinues:breakpoint.continueAfterRunningActions
                                                      breakpointHasActions:breakpoint.actions.count > 0
                                                    includeBottomHighlight:NO
                                                      useDarkerBorderColor:NO];

    Ivar iconIvar = class_getInstanceVariable(self.class, "_icon");
    object_setIvar(self, iconIvar, icon);
    
    BOOL breakpointsActive = self.breakpointsActivated.boolValue;
    BOOL enabled = self.breakpointEnabled.boolValue;

    NSImage *image = [icon cachedImageForBreakpointsActivated:breakpointsActive breakpointEnabled:enabled pressed:NO];
    self.image = image;
}

@end
