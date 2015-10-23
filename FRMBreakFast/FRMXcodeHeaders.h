//
//  FRMXcodeHeaders.h
//  FRMBreakFast
//
//  Created by Friedrich Markgraf on 22.10.15.
//  Copyright © 2015 Friedrich Markgraf. All rights reserved.
//

#ifndef FRMXcodeHeaders_h
#define FRMXcodeHeaders_h


#endif /* FRMXcodeHeaders_h */

#import <Cocoa/Cocoa.h>

@interface IDEBreakpoint : NSObject
@property BOOL continueAfterRunningActions; // @synthesize continueAfterRunningActions=_continueAfterRunningActions;
@property(copy) NSArray *actions; // @dynamic actions;
@end

@interface DVTAnnotation : NSObject
@property (strong) id representedObject;
@end

@interface DVTTextSidebarView : NSRulerView
- (DVTAnnotation *)_clickedAnnotation:(NSEvent *)event;
@end