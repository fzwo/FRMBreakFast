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


@interface IDEBreakpointManager : NSObject
@property(nonatomic) BOOL breakpointsActivated;
@end


@interface IDEBreakpoint : NSObject
@property(retain) id /*<IDEInternalBreakpointDelegate>*/ delegate;
@property BOOL continueAfterRunningActions;
@property(copy) NSArray *actions;
@property(nonatomic) BOOL shouldBeEnabled;
@end


@interface IDEFileBreakpoint : IDEBreakpoint
@end


@interface DVTDocumentLocation : NSObject
@end


@interface DVTTextDocumentLocation : DVTDocumentLocation
@property(readonly) long long startingLineNumber;
@end


@interface DVTAnnotation : NSObject
@property (strong) id representedObject;
@end


@interface DVTTextAnnotation : DVTAnnotation {
    NSImage *_sidebarMarkerImage;
}
@property(retain, nonatomic) DVTTextDocumentLocation *location;
@property(readonly) NSRange paragraphRange;
@property(retain, nonatomic) NSImage *sidebarMarkerImage;
@end


@interface DBGBreakpointAnnotation : DVTTextAnnotation
- (id)_icon;
- (id)_iconForRect:(struct CGRect)rect;
@end


@interface DVTTextSidebarView : NSRulerView
- (DVTAnnotation *)_clickedAnnotation:(NSEvent *)event;
- (DVTAnnotation *)annotationAtSidebarPoint:(struct CGPoint)point;
@end


@interface IDEBreakpointAction : NSObject
@end


@interface IDELogBreakpointAction : IDEBreakpointAction
@property(copy) NSString *message;
@end


@interface IDEBreakpointIcon : NSObject
- (id)cachedImageForBreakpointsActivated:(BOOL)arg1 breakpointEnabled:(BOOL)arg2 pressed:(BOOL)arg3;
- (id)initWithSize:(struct CGSize)arg1 includeBottomHighlight:(BOOL)arg2 useDarkerBorderColor:(BOOL)arg3;


@end


@interface DBGBreakpointButton : NSButton
@property(retain, nonatomic) NSNumber *breakpointEnabled;
@property(retain, nonatomic) NSNumber *breakpointsActivated;
@property __weak IDEBreakpoint *breakpoint;
- (void)_updateImage;
- (id)initWithBreakpointIcon:(id)arg1;
@end
