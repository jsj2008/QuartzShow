
#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <QuartzComposer/QuartzComposer.h>
#import "renderController.h"

@interface CompositionParametersView : NSView
{
	QCRenderer*					_QCRenderer;
	NSMutableArray*			_labels;
	NSMutableArray*			_controls;
	NSSize						_minSize;
	NSSize						bestSize;
	renderController *			renderingControl;
}
-(void) getRenderingControl:(renderController *) incomingRenderingControl;
- (id) initWithQCRenderer:(QCRenderer*)QCRendererer;
- (NSSize) minimumSize;
- (QCRenderer*) QCRendererer;
- (NSDictionary*) parameters:(BOOL)plistCompatible;
- (void) setParameters:(NSDictionary*)parameters;
-(NSSize) bestSize;
@end
