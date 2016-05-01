//
//  DBGBreakpointAnnotation+FRMBreakFastAdditions.m
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 30.04.16.
//  Copyright © 2016 Friedrich Markgraf. All rights reserved.
//

#import "DBGBreakpointAnnotation+FRMBreakFastAdditions.h"
#import "FRMRuntimeHelpers.h"
#import "IDEBreakpointIcon+FRMBreakFastAdditions.h"

@implementation DBGBreakpointAnnotation (FRMBreakFastAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MethodSwizzle(self,
                      @selector(_iconForRect:),
                      @selector(frm_iconForRect:));
    });
}


- (IDEBreakpointIcon *)frm_iconForRect:(struct CGRect)rect
{
    IDEBreakpointIcon *icon;
    IDEBreakpoint *breakpoint = (IDEBreakpoint *)[self representedObject];
    
    icon = [[IDEBreakpointIcon alloc] init_frm_WithSize:rect.size
                                    breakpointContinues:breakpoint.continueAfterRunningActions
                                   breakpointHasActions:breakpoint.actions.count > 0
                                 includeBottomHighlight:NO
                                   useDarkerBorderColor:NO];
    return icon;
}

@end
