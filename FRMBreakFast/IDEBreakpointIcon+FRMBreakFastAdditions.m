//
//  IDEBreakpointIcon+FRMBreakFastAdditions.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 01.05.16.
//  Copyright © 2016 Friedrich Markgraf. All rights reserved.
//

#import "IDEBreakpointIcon+FRMBreakFastAdditions.h"
#import "FRMRuntimeHelpers.h"
#import <objc/runtime.h>

@interface IDEBreakpointIcon ()
@property (nonatomic) BOOL breakpointContinues;
@property (nonatomic) BOOL breakpointHasActions;
@end

@implementation IDEBreakpointIcon (FRMBreakFastAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MethodSwizzle(self,
                      @selector(initWithSize:includeBottomHighlight:useDarkerBorderColor:),
                      @selector(init_frm_WithSize:includeBottomHighlight:useDarkerBorderColor:));
        MethodSwizzle(self,
                      @selector(cachedImageForBreakpointsActivated:breakpointEnabled:pressed:),
                      @selector(frm_cachedImageForBreakpointsActivated:breakpointEnabled:pressed:));
    });
}

- (id)init_frm_WithSize:(struct CGSize)size
 includeBottomHighlight:(BOOL)includeBottomHighlight
   useDarkerBorderColor:(BOOL)useDarkerBorderColor
{
    self = [self init_frm_WithSize:size includeBottomHighlight:includeBottomHighlight useDarkerBorderColor:useDarkerBorderColor];
    return self;
}


- (id)init_frm_WithSize:(struct CGSize)size
    breakpointContinues:(BOOL)continues
   breakpointHasActions:(BOOL)hasActions
 includeBottomHighlight:(BOOL)includeBottomHighlight
   useDarkerBorderColor:(BOOL)useDarkerBorderColor
{
    self = [self init_frm_WithSize:size includeBottomHighlight:includeBottomHighlight useDarkerBorderColor:useDarkerBorderColor];
    self.breakpointContinues = continues;
    self.breakpointHasActions = hasActions;
    return self;
}


- (NSImage *)frm_cachedImageForBreakpointsActivated:(BOOL)activated
                                  breakpointEnabled:(BOOL)enabled
                                            pressed:(BOOL)pressed
{
    Ivar sizeIvar = class_getInstanceVariable(self.class, "_size");
    ptrdiff_t offset = ivar_getOffset(sizeIvar);
    unsigned char *selfObjectBytes = (unsigned char *)(__bridge void *)self;
    CGSize size = * ((CGSize *)(selfObjectBytes + offset));

    NSColor *fillColor = [self fillColorForBreakpointsActive:activated isEnabled:enabled hasActions:self.breakpointHasActions];

    NSBezierPath *markerPath = [self pathForSize:size breakpointContinues:self.breakpointContinues];
    
    NSImage *arrowImage = [[NSImage alloc] initWithSize:size];
    [arrowImage lockFocus];
    [fillColor set];
    [markerPath fill];
    [markerPath stroke];
    [arrowImage unlockFocus];
    
    return arrowImage;
}


#pragma mark - Private Methods

- (NSBezierPath *)pathForSize:(CGSize)size breakpointContinues:(BOOL)continues
{
    CGFloat left = 0.5;
    CGFloat right = size.width - 0.5;
    CGFloat top = 0.5;
    CGFloat bottom = size.height - 0.5;
    CGFloat halfHeight = floor(size.height / 2.0) + 0.5;
    CGFloat arrowheadWidth = ceil(halfHeight/4.0*3.0);
    NSBezierPath *markerPath = [NSBezierPath bezierPath];
    [markerPath moveToPoint: NSMakePoint(left, top)];
    if (continues) {
        [markerPath lineToPoint: NSMakePoint(left + arrowheadWidth, size.height - halfHeight)];
    }
    [markerPath lineToPoint: NSMakePoint(left, bottom)];
    [markerPath lineToPoint: NSMakePoint(right - arrowheadWidth, bottom)];
    [markerPath lineToPoint: NSMakePoint(right, size.height - halfHeight)];
    [markerPath lineToPoint: NSMakePoint(right - arrowheadWidth, top)];
    [markerPath lineToPoint: NSMakePoint(left, top)];
    return markerPath;
}


- (NSColor *)fillColorForBreakpointsActive:(BOOL)breakpointsActive isEnabled:(BOOL)enabled hasActions:(BOOL)hasActions
{
    NSColor *color;
    if (!breakpointsActive) {
        if (enabled) {
            color = [NSColor colorWithCalibratedRed:0.541 green:0.549 blue:0.561 alpha:1.000];
        }
        else {
            color = [NSColor colorWithCalibratedRed:0.765 green:0.773 blue:0.780 alpha:1.000];
        }
    }
    else if (hasActions) {
        if (enabled) {
            color = [NSColor colorWithCalibratedRed:0.661 green:0.254 blue:0.698 alpha:1];
        }
        else {
            color = [NSColor colorWithCalibratedRed:0.866 green:0.712 blue:0.879 alpha:1];
        }
    }
    else {
        if (enabled) {
            color = [NSColor colorWithCalibratedRed:0.255 green:0.443 blue:0.698 alpha:1.000];
        }
        else {
            color = [NSColor colorWithCalibratedRed:0.710 green:0.792 blue:0.878 alpha:1.000];
        }
    }
    return color;
}


#pragma mark - Associated Object Accessors

- (void)setBreakpointContinues:(BOOL)breakpointContinues
{
    objc_setAssociatedObject(self, @selector(breakpointContinues), [NSNumber numberWithBool:breakpointContinues], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)breakpointContinues
{
    NSNumber *boolNumber = objc_getAssociatedObject(self, @selector(breakpointContinues));
    return boolNumber.boolValue;
}


- (void)setBreakpointHasActions:(BOOL)breakpointHasActions
{
    objc_setAssociatedObject(self, @selector(breakpointHasActions), [NSNumber numberWithBool:breakpointHasActions], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)breakpointHasActions
{
    NSNumber *boolNumber = objc_getAssociatedObject(self, @selector(breakpointHasActions));
    return boolNumber.boolValue;
}

@end
