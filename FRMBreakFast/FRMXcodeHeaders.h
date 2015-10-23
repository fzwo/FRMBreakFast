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

@interface DVTTextAnnotation : DVTAnnotation
@property(retain, nonatomic) DVTTextDocumentLocation *location;
@property(readonly) NSRange paragraphRange;
@end

@interface DBGBreakpointAnnotation : DVTTextAnnotation
@end

@interface DVTTextSidebarView : NSRulerView
@property double foldbarWidth;
- (DVTAnnotation *)_clickedAnnotation:(NSEvent *)event;
typedef void(^getParaRectBlock)(unsigned long long, CGRect *, CGRect *, DVTTextAnnotation *);
- (void)_drawSidebarMarkersForAnnotations:(NSArray *)annotations
                                atIndexes:(NSIndexSet *)indexes
                                 textView:(id)textView
                         getParaRectBlock:(getParaRectBlock)getParaRect;
- (void)_drawLineNumbersInSidebarRect:(CGRect)sidebarRect
                        foldedIndexes:(unsigned long long *)foldedIndexes
                                count:(unsigned long long)count
                        linesToInvert:(id)linesToInvert
                       linesToReplace:(id)linesToReplace
                     getParaRectBlock:(getParaRectBlock)getParaRect;
- (DVTAnnotation *)annotationAtSidebarPoint:(struct CGPoint)point;
- (void)getParagraphRect:(struct CGRect *)paragraphRect
           firstLineRect:(struct CGRect *)firstLineRect
           forLineNumber:(unsigned long long)lineNumber;
- (unsigned long long)lineNumberForPoint:(struct CGPoint)arg1;
- (struct CGRect)sidebarRect;
@end

@interface IDEBreakpointAction : NSObject
@end

@interface IDELogBreakpointAction : IDEBreakpointAction
@property(copy) NSString *message;
@end