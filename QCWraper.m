#import "QCWraper.h"
#import "PreDefine.h"


@implementation QCWraper

-(void) initOpenGLWithRect:(NSRect) Rect{
	
	NSOpenGLPixelFormatAttribute attributes[] ={
		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADepthSize,32,
		(NSOpenGLPixelFormatAttribute) 0
	};
	renderPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes]  ;
	
	renderFPS = 60.0;
	startTime = 0;
	long value = 1;
	[renderOpenGLContext setValues:&value
				forParameter:kCGLCPSwapInterval];
	
	pixelsWidth = Rect.size.width;
	pixelsHeight = Rect.size.height;
	
	renderPixelBuffer = [[NSOpenGLPixelBuffer alloc] initWithTextureTarget:GL_TEXTURE_RECTANGLE_EXT
											   textureInternalFormat:GL_RGBA 
											   textureMaxMipMapLevel:0 
														  pixelsWide:pixelsWidth
														  pixelsHigh:pixelsHeight] ;
	
	
	renderOpenGLContext = [[NSOpenGLContext alloc] initWithFormat:renderPixelFormat shareContext:nil] ;
	
	[renderOpenGLContext setPixelBuffer:renderPixelBuffer
					  cubeMapFace:0
					  mipMapLevel:0
			 currentVirtualScreen:[renderOpenGLContext currentVirtualScreen]];
		
}

-(void) initRendererWithFile:(NSString* ) filePath{
	
	if (renderer != nil) {
		[renderer release];
	}
	
	renderer =  [[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
											  pixelFormat:renderPixelFormat
															 file:filePath];
	if (renderer == nil) {
		NSLog(@"Create Renderer Fail\n");
	}
}

-(void) setOpenGLView:(NSView * ) View{
	[renderOpenGLContext  setView: View];
}

-(void) startRendering{
	if (renderStatus == RenderStatusRendering) {
		return ;
	}
	renderStatus = RenderStatusRendering;
	[NSThread detachNewThreadSelector:@selector(threadRender:)
							 toTarget:self
						   withObject:nil];
	
}
- (BOOL) isRendering;{
	if (renderStatus == RenderStatusRendering) {
		return YES;
	}
	
	return NO;
}

-(void) stopRendering{
	if (renderStatus == RenderStatusRendering) {
		CFRunLoopStop(renderThreadRunLoop);
		renderStatus = RenderStatusHalt;
	}
}

-(void) threadRender:(id) sender{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	renderThreadRunLoop = [[NSRunLoop currentRunLoop] getCFRunLoop];
	NSTimer *  renderTimer = [[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval )(1.0/ renderFPS)
															   target:self
															 selector:@selector(renderOpenGLView:)
															 userInfo:nil
															  repeats:YES] retain];
	
	[[NSRunLoop currentRunLoop] addTimer:renderTimer forMode:NSDefaultRunLoopMode];
	[renderTimer release];
	
	CFRunLoopRun();
	[pool release];
}

-(void)  renderOpenGLView:(id) sender{
	time = [NSDate timeIntervalSinceReferenceDate];
	if (startTime == 0) {
		startTime = time;
		time = 0;
	}else {
		time = time - startTime;
	}
	if (![renderer renderAtTime:time arguments:nil]) {
		printf("Renderer failed at time %.3f\n",time);
	}
	[renderOpenGLContext flushBuffer];
	
} 



-(void) renderAtTime:(NSTimeInterval) specifiedTime{
	
	[renderer renderAtTime:specifiedTime arguments:nil];
	[renderOpenGLContext flushBuffer];
}

-(void) clean{
	
	
	[self stopRendering];
	
	if (renderer != nil) {
		[renderer release];
	}
	
	[renderOpenGLContext clearDrawable];
	[renderOpenGLContext release];
	[renderPixelFormat release];
	[renderPixelBuffer release];
	
}

-(NSTimeInterval) getCurrentRenderTime{
	return time ;
}

- (float) maxRenderingFrameRate{
	return renderFPS ;
}

- (void) setMaxRenderingFrameRate:(float)maxFPS{
	if (maxFPS  == 0) {
		maxFPS  = 60;
	}
	renderFPS  = maxFPS ;
	[self stopRendering ];
	[self startRendering ];
}

- (BOOL) setValue:(id)value forInputKey:(NSString*)key_t{
	  return [renderer setValue: value  forInputKey:key_t];
}

-(int) getRenderStatuts{
	return renderStatus ;
}

- (id) valueForInputKey:(NSString*)key{
	return [renderer valueForInputKey: key];
}

- (id) valueForOutputKey:(NSString*)key{
	return [renderer valueForOutputKey: key];
}

-(NSDictionary*) attributes{
	return [renderer attributes ];	
}

-(NSArray*) inputKeys{
	return [renderer inputKeys];
}
-(NSArray*) outputKeys{
	return [renderer outputKeys ];
}
//Generate CoreImage here!
-(CIImage * ) generateCIImageObject:(NSTimeInterval) specifiedTime{
	
	cglContext = [renderOpenGLContext CGLContextObj];
	CGLSetCurrentContext(cglContext);
	
	bitmapRowBytes = 4 * pixelsWidth;
	bitmapRowBytes = (bitmapRowBytes + 3) & ~3;
	
	data = malloc(pixelsHeight * bitmapRowBytes);
	[renderer renderAtTime:specifiedTime  arguments:nil];
		
	cgBitmap = CGBitmapContextCreate(data,
									 pixelsWidth, pixelsHeight ,
									 8, bitmapRowBytes,
									 CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB),
									 kCGImageAlphaPremultipliedLast);
	
	if (cgBitmap == NULL) {
		printf("CGBitmapContextCreate Failed\n");
		free(data);
		return nil ;
	}
	
	glFinish(); 
	glPixelStorei(GL_PACK_ALIGNMENT, 4); 
	glPixelStorei(GL_PACK_ROW_LENGTH, 0);
	glPixelStorei(GL_PACK_SKIP_ROWS, 0);
	glPixelStorei(GL_PACK_SKIP_PIXELS, 0);	
	
	glReadPixels(0,0,
				 pixelsWidth, pixelsHeight , 
				 GL_RGBA,
				 GL_UNSIGNED_INT_8_8_8_8_REV,
				 data);
	
	swizzleBitmap(data, bitmapRowBytes, pixelsHeight);
	cgImage  = CGBitmapContextCreateImage(cgBitmap );
	if (cgImage == NULL) {
		printf("CGBitmapContextCreateImage failed\n");
		CFRelease(cgBitmap );
		free(data);
		return nil ;
	}
	
	CGLSetCurrentContext(NULL );
	
	CIImage * drawImage = [[CIImage alloc] initWithCGImage:cgImage ];
	
	CFRelease(cgBitmap );
	CFRelease( cgImage );
	free(data );
	
	return drawImage;
}


@end
