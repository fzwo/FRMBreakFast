//
//  DVTTextSidebarView+FRMBreakFastAdditions.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 22.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#import "DVTTextSidebarView+FRMBreakFastAdditions.h"
#import "FRMRuntimeHelpers.h"

@implementation DVTTextSidebarView (FRMBreakFastAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MethodSwizzle(self,
                      @selector(mouseDown:),
                      @selector(frm_mouseDown:));
    });
}


- (void)frm_mouseDown:(NSEvent *)event
{
    [self logEvent:event];
    DVTAnnotation *clickedAnnotation = [self _clickedAnnotation:event];
    NSLog(@"FRMBreakFast: Clicked Annotation %@\nrepresentedObject %@", clickedAnnotation, [clickedAnnotation representedObject]);
    if (clickedAnnotation) {
        if ([clickedAnnotation.representedObject isKindOfClass:[IDEBreakpoint class]]) {
            IDEBreakpoint *breakpoint = clickedAnnotation.representedObject;
            [self logBreakpoint:breakpoint];
        }
    }
    
    [self frm_mouseDown:event];
}


- (void)logEvent:(NSEvent *)event
{
    NSEventModifierFlags flags = event.modifierFlags & NSDeviceIndependentModifierFlagsMask;
    BOOL altKeyPressed = (flags & NSAlternateKeyMask) != 0;
    BOOL commandKeyPressed = (flags & NSCommandKeyMask) != 0;
    BOOL shiftKeyPressed = (flags & NSShiftKeyMask) != 0;
    NSPoint locationInSelf = [self convertPoint:event.locationInWindow fromView:nil];
    NSLog(@"FRMBreakFast: loc in window: %@\nloc in view: %@\nAlt: %d cmd: %d ctrl: %lu shift: %d; mod: %ld",
          NSStringFromPoint(event.locationInWindow),
          NSStringFromPoint(locationInSelf),
          altKeyPressed,
          commandKeyPressed,
          flags & NSControlKeyMask,
          shiftKeyPressed,
          flags);
}

- (void)logBreakpoint:(IDEBreakpoint *)breakpoint
{
    NSLog(@"%@ continueAfterRunningActions: %@, actions: %@", breakpoint.debugDescription, breakpoint.continueAfterRunningActions ? @"YES" : @"NO", breakpoint.actions);
}

@end
