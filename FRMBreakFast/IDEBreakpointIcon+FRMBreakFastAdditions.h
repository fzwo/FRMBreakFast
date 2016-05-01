//
//  IDEBreakpointIcon+FRMBreakFastAdditions.h
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 01.05.16.
//  Copyright © 2016 Friedrich Markgraf. All rights reserved.
//

#import "FRMXcodeHeaders.h"

@interface IDEBreakpointIcon (FRMBreakFastAdditions)

- (id)init_frm_WithSize:(struct CGSize)size
    breakpointContinues:(BOOL)continues
   breakpointHasActions:(BOOL)hasActions
 includeBottomHighlight:(BOOL)includeBottomHighlight
   useDarkerBorderColor:(BOOL)useDarkerBorderColor;

@end
