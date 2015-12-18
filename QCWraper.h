//
//  QCWraper.h
//  temp
//
//  Created by Tiger on 3/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzComposer/QuartzComposer.h>
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>
#import <OpenGL/OpenGL.h>
#import "PreDefine.h"






@interface QCWraper : NSObject {
	QCRenderer * renderer ;
	NSOpenGLContext * renderOpenGLContext;
	NSOpenGLPixelBuffer * renderPixelBuffer;
	NSOpenGLPixelFormat * renderPixelFormat;
	NSTimeInterval			startTime;
	NSTimeInterval			time;
	float						renderFPS;
	
	//== CoreFoundatin Member
	CFRunLoopRef renderThreadRunLoop;
	CGLContextObj cglContext;
	int renderStatus;
		
	//==CoreImage Member
	int bitmapRowBytes ;
	int pixelsWidth; 
	int pixelsHeight;
	CGContextRef cgBitmap;
	CGImageRef cgImage;
	void * data;

}
-(void) initOpenGLWithRect:(NSRect) rect;
-(void) initRendererWithFile:(NSString* ) filePath;
-(void) setOpenGLView:(NSView * ) View;
-(void) startRendering;
-(void) stopRendering;
-(void) clean;
-(void) renderAtTime:(NSTimeInterval) specifiedTime;

-(CIImage * ) generateCIImageObject:(NSTimeInterval) specifiedTime;


-(NSTimeInterval) getCurrentRenderTime;
- (BOOL) isRendering;


- (BOOL) setValue:(id)value forInputKey:(NSString*)key;
- (id) valueForInputKey:(NSString*)key;
- (id) valueForOutputKey:(NSString*)key;

-(NSDictionary*) attributes;
-(NSArray*) inputKeys;
-(NSArray*) outputKeys;

- (float) maxRenderingFrameRate;
- (void) setMaxRenderingFrameRate:(float)maxFPS;

@end
