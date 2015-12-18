
#import <Cocoa/Cocoa.h>
#import <QuartzComposer/QCView.h>
#import <QuartzCore/QuartzCore.h>
#import "preferenceWindowController.h"
#import "subWindow.h"
#import "CIImageDrawView.h"
#import "screenSaverShow.h"
#import "QCWraper.h"
#import "CoreTabView.h"
#import "PreDefine.h"
#import "CustomAnimation.h"


@interface renderController : NSObject {
	NSSize					screenSize;
	NSRect				renderWindowRect;
	NSWindow	*		renderWindow;
	QCView		*		renderQCView;
	QCRenderer      *		renderer;
	NSString		*		selfFileName;
	CoreTabView *  renderAnimatingTabView;
	NSTabViewItem *		renderTabViewItem;
	
	CustomAnimation * animation ;
	
	
	CIImage * inputShadingImage;
	CIImage * inputMaskImage;
	
	
	IBOutlet	NSMenuItem * preferenceMenuItem;
	IBOutlet	preferenceWindowController * animationControl;
	id screenSaverControl;
	
	//to replace the QCView with the QCWraper
	QCWraper * renderWraperFront;
	QCWraper * renderWraperBack;
	
	CIImageDrawView * drawViewFront;
	CIImageDrawView *drawViewBack;
	
	CIFilter * coreFilter;
	CIFilter * transitionFilter;
	
	int count ;
	float renderFPS;
	NSTimeInterval startTime;
	NSTimeInterval time;
	int pixelsHeight;
	int pixelsWidth;
	int renderStatus;
	
	//==CoreImage Member
	int bitmapRowBytes ;
	CGContextRef cgBitmap;
	CGImageRef cgImage;
	CGLContextObj cglContext;
	void * data;
	CIImage * inputImage ;
	CIImage * inputTargetImage;
	
	NSOpenGLPixelFormat * renderPixelFormat;
	NSOpenGLContext * renderOpenGLContext;
	NSOpenGLPixelBuffer * renderPixelBuffer;
	
	CFRunLoopRef renderThreadRunLoop;
	
	NSBundle * bundle;
	NSData *shadingBitmapData;
	NSBitmapImageRep *shadingBitmap;
	NSData *maskBitmapData ;
	NSBitmapImageRep *maskBitmap;
	
}
-(void) initOpenGL;
-(void) destroyOpenGL;
-(void) initRendering:(id) plugIn;
-(void) renderingStart;
-(void) renderingStop;
-(void) renderingFile:(NSString *) fileName;
-(float) getCurrentRenderingFPS;
-(void ) setFPS:(float) specifiedFPS;
-(void) drawCIImage;
-(QCRenderer *) getQCRenderer;
-(NSString *) getQCRendererName;
//-(IBAction) setFPS:(id) sender;
- (void) createTransitionForRect:(NSRect) rect initialCIImage:(CIImage*) initialCIImage  finalCIImage:(CIImage *) finalCIImage forType:(int) transitionType;
-(CIImage * ) generateCIImageObject:(NSTimeInterval) specifiedTime;
@end




