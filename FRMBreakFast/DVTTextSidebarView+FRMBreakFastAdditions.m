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
        MethodSwizzle(self,
                      @selector(_drawSidebarMarkersForAnnotations:atIndexes:textView:getParaRectBlock:),
                      @selector(frm_drawSidebarMarkersForAnnotations:atIndexes:textView:getParaRectBlock:));
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
    NSLog(@"FRMBreakFast: After mouseDown");
    
    NSEventModifierFlags flags = event.modifierFlags & NSDeviceIndependentModifierFlagsMask;
    BOOL commandKeyPressed = (flags & NSCommandKeyMask) != 0;
    BOOL shiftKeyPressed = (flags & NSShiftKeyMask) != 0;
    NSPoint locationInSelf = [self convertPoint:event.locationInWindow fromView:nil];

    DVTAnnotation *annotation = [self annotationAtSidebarPoint:locationInSelf];
    if (annotation && clickedAnnotation == nil && commandKeyPressed && shiftKeyPressed) {
        if ([annotation.representedObject isKindOfClass:[IDEBreakpoint class]]) {
            IDEBreakpoint *breakpoint = annotation.representedObject;
            //set newly created breakpoint to continue after actions
            breakpoint.continueAfterRunningActions = YES;
            //add logging action to breakpoint
            IDELogBreakpointAction *action = [[IDELogBreakpointAction alloc] init];
            action.message = @"%B %H";
            breakpoint.actions = @[action];
            [self logBreakpoint:breakpoint];
        }
    }
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


- (void)frm_drawSidebarMarkersForAnnotations:(NSArray *)annotations
                                   atIndexes:(NSIndexSet *)indexes
                                    textView:(id)textView
                            getParaRectBlock:(getParaRectBlock)getParagraphRect
{
    NSMutableIndexSet *unhandledAnnotationsIndexes = [NSMutableIndexSet indexSet];
    NSUInteger i = 0;
    for (DVTAnnotation *annotation in annotations) {
        id representedObject = annotation.representedObject;
        
        //handle ordinary (non-symbolic, non-exception) breakpoints only
        if ([representedObject isKindOfClass:IDEFileBreakpoint.class]) {
            DBGBreakpointAnnotation *breakpointAnnotation = (DBGBreakpointAnnotation *)annotation;
            DVTTextDocumentLocation *location = breakpointAnnotation.location;
            long long startingLineNumber = location.startingLineNumber + 1;
            CGRect paragraphRect;
            CGRect firstLineRect;
            [self getParagraphRect:&paragraphRect firstLineRect:&firstLineRect forLineNumber:startingLineNumber];
            
            //correct rects for unsaved edits
            NSRange paragraphRange = breakpointAnnotation.paragraphRange;
            getParagraphRect(paragraphRange.location + 1, &paragraphRect, &firstLineRect, nil);
            
            //draw
            NSBezierPath *markerPath = [self markerPathForBreakpointAnnotation:breakpointAnnotation inRect:firstLineRect];
            NSColor *fillColor = [self colorForBreakpointAnnotation:breakpointAnnotation];
            NSColor *strokeColor = fillColor;
            [fillColor setFill];
            [strokeColor setStroke];
            [markerPath fill];
            [markerPath stroke];
        }
        else {
            [unhandledAnnotationsIndexes addIndex:i];
        }
        i++;
    }
    
    //let original implementation handle all unhandled annotations
    [self frm_drawSidebarMarkersForAnnotations:annotations atIndexes:unhandledAnnotationsIndexes textView:textView getParaRectBlock:getParagraphRect];
    
    //ensure that line numbers are drawn on top of sidebar annotations
    [self _drawLineNumbersInSidebarRect:[self sidebarRect] foldedIndexes:nil count:0 linesToInvert:nil linesToReplace:nil getParaRectBlock:getParagraphRect];
}


- (NSBezierPath *)markerPathForBreakpointAnnotation:(DBGBreakpointAnnotation *)annotation
                                             inRect:(CGRect)rect
{
    IDEFileBreakpoint *breakpoint = (IDEFileBreakpoint *)[annotation representedObject];
    
    CGFloat left = rect.origin.x + 0.5;
    CGFloat right = NSMaxX(rect) + 0.5;
    CGFloat top = rect.origin.y + 0.5;
    CGFloat bottom = NSMaxY(rect) - 0.5;
    CGFloat halfHeight = floor(rect.size.height / 2.0) + 0.5;
    CGFloat arrowheadWidth = ceil(halfHeight/4.0*3.0);
    NSBezierPath *markerPath = [NSBezierPath bezierPath];
    [markerPath moveToPoint: NSMakePoint(left, top)];
    if (breakpoint.continueAfterRunningActions) {
        [markerPath lineToPoint: NSMakePoint(left + arrowheadWidth, NSMaxY(rect) - halfHeight)];
    }
    [markerPath lineToPoint: NSMakePoint(left, bottom)];
    [markerPath lineToPoint: NSMakePoint(right, bottom)];
    [markerPath lineToPoint: NSMakePoint(right + arrowheadWidth, NSMaxY(rect) - halfHeight)];
    [markerPath lineToPoint: NSMakePoint(right, top)];
    [markerPath lineToPoint: NSMakePoint(left, top)];
    return markerPath;
}


- (NSColor *)colorForBreakpointAnnotation:(DBGBreakpointAnnotation *)annotation
{
    IDEFileBreakpoint *breakpoint = (IDEFileBreakpoint *)[annotation representedObject];
    BOOL breakpointsActive = YES;
    if ([breakpoint.delegate isKindOfClass:IDEBreakpointManager.class]) {
        breakpointsActive = [(IDEBreakpointManager *)breakpoint.delegate breakpointsActivated];
    }
    BOOL enabled = breakpoint.shouldBeEnabled;
    BOOL hasActions = breakpoint.actions.count > 0;
    
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


@end
