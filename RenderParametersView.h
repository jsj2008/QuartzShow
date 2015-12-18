

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
//#import "CoreImageAnimation.h"
//#import "QCWraper.h"
#import <QuartzComposer/QuartzComposer.h>

@interface RenderParametersView : NSView
{
	NSMutableArray*					_QCRenderers;
	NSSize								_bestSize;
}
- (void) addQCRender:(QCRenderer *)QCRendererer title:(NSString*)title;
- (void) removeQCRenderer:(QCRenderer*)QCRendererer;
- (void) removeAllQCRenderers;
- (NSArray*) QCRenderers;
- (NSSize) bestSize;
- (NSDictionary*) parameters:(BOOL)plistCompatible;
- (void) setParameters:(NSDictionary*)parameters;
@end;

