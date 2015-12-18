//
//  renderController.m
//  QuartzShow
//
//  Created by Tiger on 2/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "renderController.h"


@implementation renderController
-(void) awakeFromNib{
	/*NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSData *shadingBitmapData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]];
	 NSBitmapImageRep *shadingBitmap = [[[NSBitmapImageRep alloc] initWithData:shadingBitmapData] autorelease];
	 inputShadingImage =[ [[CIImage alloc] initWithBitmapImageRep:shadingBitmap] retain];
		 
	 NSData *maskBitmapData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
	 NSBitmapImageRep *maskBitmap = [[[NSBitmapImageRep alloc] initWithData:maskBitmapData] autorelease];
	 inputMaskImage = [[CIImage alloc] initWithBitmapImageRep:maskBitmap];
	 printf("Execute at the RenderController awakeFromNib\n");*/
}

-(void) initRendering:(id) plugIn{

	
	bundle = [NSBundle bundleForClass:[self class]];
	shadingBitmapData = [NSData dataWithContentsOfFile:
		[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]] ;
	
	shadingBitmap = [[NSBitmapImageRep alloc] initWithData:shadingBitmapData] ;
	inputShadingImage = [[CIImage alloc] initWithBitmapImageRep:shadingBitmap] ;
	
	maskBitmapData = [NSData dataWithContentsOfFile:
		[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
	
	maskBitmap = [[NSBitmapImageRep alloc] initWithData:maskBitmapData] ;
	inputMaskImage = [[CIImage alloc] initWithBitmapImageRep:maskBitmap];
	
	count = 0;
	renderStatus = RenderStatusHalt;
	
	screenSaverControl = [plugIn retain];
	screenSize.width = CGDisplayPixelsWide(kCGDirectMainDisplay);
	screenSize.height = CGDisplayPixelsHigh(kCGDirectMainDisplay);
	screenSize.height = screenSize.height - [NSMenuView menuBarHeight];

	renderWindowRect = NSMakeRect(0,0,screenSize.width,screenSize.height);
	renderWindow = [[NSWindow alloc]
						initWithContentRect:renderWindowRect
								  styleMask:nil 
									backing:NSBackingStoreBuffered
									  defer:NO];
	
	animationControl = [[preferenceWindowController alloc] init];
	[animationControl initialize];

	 [renderWindow setBackgroundColor: [NSColor colorWithCalibratedWhite:0.0 alpha:0.0]];
	[renderWindow setOpaque:NO];
	[renderWindow display];
	[renderWindow setLevel:kCGDesktopWindowLevel];
	[renderWindow setIgnoresMouseEvents:YES];

	renderAnimatingTabView = [[CoreTabView alloc] init];
	
	renderTabViewItem = [[NSTabViewItem alloc] init];
	drawViewFront = [[CIImageDrawView alloc] init];
	[renderTabViewItem setView:drawViewFront];
	[renderAnimatingTabView addTabViewItem:renderTabViewItem ];
	//=======================================================================
	renderTabViewItem = [[NSTabViewItem alloc] init];
	drawViewBack = [[CIImageDrawView alloc] init];
	[renderTabViewItem setView:drawViewBack];
	[renderAnimatingTabView addTabViewItem:renderTabViewItem];
	
	//=======================================================================

	[renderAnimatingTabView setTabViewType:NSNoTabsNoBorder];
	[renderAnimatingTabView setDrawsBackground:NO];
	[renderWindow setContentView:renderAnimatingTabView];
	[renderWindow makeKeyAndOrderFront:nil];
	
	//*******************************************************************************************
	[preferenceMenuItem setEnabled:NO];
	//init OpenGL Context here!
	
	renderFPS = 60.0;
	startTime = 0;
	
	
}
//========================================================================
-(void) renderingFile:(NSString *) fileName{
	
		
	
	selfFileName = [NSString stringWithString:fileName];
	[selfFileName retain];
	
	
	int animationTag = [animationControl animationEffect];
	double animationDuration = [animationControl animationDuration];
	[screenSaverControl endShow];
	startTime  = 0;
	CIImage * tempImage;
	if (animationTag  < 10) {
		// here is the CoreGraphics Transition
		[renderAnimatingTabView setCGSTransitionEffect:
			tagToCGSTransitionType(animationTag)];
		[renderAnimatingTabView setCGSTransitionDuration:animationDuration];
		[renderAnimatingTabView setCGSTransitionOption:
		directionTagToTransitionOption([animationControl animationDirection])];
				
		if (count == 0) {
			//There is no a renderWraper Rendering;		
			[self initOpenGL];
			renderer  =[[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													 pixelFormat:renderPixelFormat
															file:fileName];
			[renderAnimatingTabView setCGSTransitionEffect:CGSNone];
			[renderAnimatingTabView selectTabViewItemAtIndex:0];
			[renderOpenGLContext setView:drawViewFront];
			if (renderStatus == RenderStatusRendering) {
				return ;
			}
			renderStatus = RenderStatusHalt;
			[self renderingStart];			
			count = 1;
			
		}else if (count == 1) {
				
			[self renderingStop];
			[renderOpenGLContext flushBuffer];
			
			tempImage =[self generateCIImageObject:time];
			[drawViewFront getCIImage:tempImage ];
			[drawViewFront display];
			if (renderer != nil) {
				[renderer release];
			}
			[renderOpenGLContext clearDrawable];
			[self destroyOpenGL];
			[tempImage release];
			[self initOpenGL];
						
			renderer = [[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													 pixelFormat:renderPixelFormat
															file:fileName];
			
			tempImage = [self generateCIImageObject:(NSTimeInterval) 0.0];
			
			[drawViewBack getCIImage: tempImage];
			[drawViewBack display];
		//	printf("Is going to selectTabView index 1\n");
			
			[renderAnimatingTabView selectTabViewItemAtIndex: 1];
			[renderOpenGLContext  setView:drawViewBack];
			renderStatus =  RenderStatusHalt;
			[self renderingStart];
			[tempImage release];
			
			count = 2;
						
		}else if (count == 2) {
			[self renderingStop];
				
			[renderOpenGLContext flushBuffer];
			
			tempImage = [self generateCIImageObject:time];
			[drawViewBack getCIImage: tempImage];
			[drawViewBack display];
			
			if (renderer != nil) {
				[renderer release];
			}
			[renderOpenGLContext clearDrawable];
			[self destroyOpenGL];
			[tempImage release];
			[self initOpenGL];
			
			renderer =[[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													pixelFormat:renderPixelFormat
														   file:fileName];	
			tempImage = [self generateCIImageObject:(NSTimeInterval) 0.0];
			[drawViewFront getCIImage:tempImage];
			[drawViewFront display];
			
			[renderAnimatingTabView selectTabViewItemAtIndex:0];
			[renderOpenGLContext setView:drawViewFront];
			renderStatus = RenderStatusHalt;
			[self renderingStart];
			[tempImage release];
			count =1;
			
		}

		
		
	}else {
		//here is the CoreImage Transition
		if (count == 0) {
			[self initOpenGL];
			renderer = [[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													 pixelFormat:renderPixelFormat
															file:fileName];
			[renderAnimatingTabView setCGSTransitionEffect:CGSNone];
			[renderAnimatingTabView selectTabViewItemAtIndex:0];
			[renderOpenGLContext setView:drawViewFront];
			if (renderStatus == RenderStatusRendering) {
				return ;
			}
			renderStatus = RenderStatusHalt;
			[self renderingStart];
			count =1 ;
			
		}else if (count == 1) {
			
			[self renderingStop];
			if (inputImage != nil) {
				[inputImage release];
			}
			if (inputTargetImage != nil) {
				[inputTargetImage release];
			}
						
			inputImage = [self generateCIImageObject:time];
			[drawViewFront getCIImage:inputImage ];
			[drawViewFront display];
			
			if (renderer != nil) {
				[renderer release];
			}
			[renderOpenGLContext clearDrawable];
			[self destroyOpenGL];
			[self initOpenGL];
			
			renderer  = [[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													  pixelFormat:renderPixelFormat
															 file:fileName];
						
			 inputTargetImage =[self generateCIImageObject:(NSTimeInterval) 0.0] ;
			
			[drawViewBack getCIImage: inputTargetImage];
			[drawViewBack display];
			
			//to start core image effect here!
			if (inputImage != nil && inputTargetImage != nil) {
				[self createTransitionForRect:[drawViewFront frame]
										initialCIImage:inputImage
										  finalCIImage:inputTargetImage
											   forType:animationTag];
				
			
				
				animation = [[CustomAnimation alloc] initWithDuration:animationDuration animationCurve:NSAnimationEaseInOut];
				[animation setDelegate:self];
				[animation startAnimation];
				[animation release];
			
			}
			[transitionFilter release];
			[renderAnimatingTabView setCGSTransitionEffect:CGSNone];
			[renderAnimatingTabView selectTabViewItemAtIndex: 1];
			[renderOpenGLContext setView: drawViewBack];
			renderStatus = RenderStatusHalt;
		//	printf("ExecutePoint:CoreImage/Count = 1/Before Self renderingStart\n");
			[self renderingStart];
			count =2;	
			
		} else if (count == 2) {
		
			[self renderingStop];
			if (inputImage != nil) {
				[inputImage release];
			}
			if (inputTargetImage != nil) {
				[inputTargetImage release];
			}
			
			inputImage = [self generateCIImageObject:time];
			[drawViewBack getCIImage:inputImage];
			[drawViewBack display];
			if (renderer != nil) {
				[renderer release];
			}
			[renderOpenGLContext clearDrawable];
			[self destroyOpenGL];
			[self initOpenGL];
			
			renderer = [[QCRenderer alloc] initWithOpenGLContext:renderOpenGLContext
													 pixelFormat:renderPixelFormat
															file:fileName];
			inputTargetImage = [self generateCIImageObject:(NSTimeInterval) 0.0];
			[drawViewFront getCIImage:inputTargetImage];
			[drawViewFront display];
			
			if (inputImage != nil && inputTargetImage  != nil) {
					[self createTransitionForRect:[drawViewBack frame ]
								   initialCIImage:inputImage
									 finalCIImage:inputTargetImage 
										  forType:animationTag];
				
				animation = [[CustomAnimation alloc] initWithDuration:animationDuration 
													   animationCurve:NSAnimationEaseInOut];
				[animation setDelegate: self];
				[animation startAnimation];
				[animation release];
			
			}
			[transitionFilter release];
			[renderAnimatingTabView setCGSTransitionEffect:CGSNone ];
			[renderAnimatingTabView selectTabViewItemAtIndex: 0];
			[renderOpenGLContext setView: drawViewFront];
			renderStatus = RenderStatusHalt;
			[self renderingStart];
			count = 1;
		} 
	}

}
-(void) renderingStart{
	
	if (renderStatus == RenderStatusRendering) {
		return;
	}
	renderStatus = RenderStatusRendering;
	[NSThread detachNewThreadSelector:@selector(threadRender:)
							 toTarget:self
						   withObject:nil];
}
-(void) renderingStop{
	if (renderStatus == RenderStatusHalt) {
		return;
	}
	renderStatus = RenderStatusHalt;
	CFRunLoopStop(renderThreadRunLoop);
	
}

-(void) setFPS:(float) specifiedFPS{

	if (specifiedFPS == 0) {
		specifiedFPS = 60;
	}
	renderFPS  = specifiedFPS;
	[self renderingStop];
	[self renderingStart];

}

-(float) getCurrentRenderingFPS{
	return renderFPS;
}

-(QCRenderer  *) getQCRenderer{
	return renderer ;
}
-(NSString *) getQCRendererName{
	return selfFileName;
}

-(void) drawCIImage{
	//if (animation != nil) {
		if (count == 1) {
			[transitionFilter setValue:[NSNumber numberWithFloat:[animation currentValue]]
						  forKey:@"inputTime"];
			CIImage * outputImage = [transitionFilter valueForKey:@"outputImage"];
			[drawViewFront getCIImage:outputImage];
			[drawViewFront display];
			
		}else if (count == 2) {
			[transitionFilter setValue:[NSNumber numberWithFloat:[animation currentValue]]
						  forKey:@"inputTime"];
			CIImage * outputImage = [transitionFilter valueForKey:@"outputImage"];
			[drawViewBack getCIImage:outputImage];
			[drawViewBack display];
			
		}
			
//	}
}


- (void) createTransitionForRect:(NSRect) rect initialCIImage:(CIImage*) initialCIImage  finalCIImage:(CIImage *) finalCIImage forType:(int) transitionType{
	
	
	CIFilter *maskScalingFilter = nil;
	CGRect maskExtent;
	

	
	switch (transitionType) {
		case 10://CICopyMachine
				transitionFilter =[ [CIFilter filterWithName:@"CICopyMachineTransition"] retain];
				[transitionFilter setDefaults];
				[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
				break;
		case 11://CIDisintegrate
				transitionFilter = [[CIFilter filterWithName:@"CIDisintegrateWithMaskTransition"] retain];
				[transitionFilter setDefaults];
	           
				maskScalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
				[maskScalingFilter setDefaults];
				maskExtent = [inputMaskImage extent];
				float xScale = rect.size.width / maskExtent.size.width;
				float yScale = rect.size.height / maskExtent.size.height;
				[maskScalingFilter setValue:[NSNumber numberWithFloat:yScale] forKey:@"inputScale"];
				[maskScalingFilter setValue:[NSNumber numberWithFloat:xScale / yScale] forKey:@"inputAspectRatio"];
				[maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
				[transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"];
				break;
		case 12://CIDissolve:
				transitionFilter = [[CIFilter filterWithName:@"CIDissolveTransition"] retain];
				[transitionFilter setDefaults];
				break;
			
		case 13://CIFlash:
				transitionFilter = [[CIFilter filterWithName:@"CIFlashTransition"] retain];
				[transitionFilter setDefaults];
				[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
				[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
				break;
			
		case 14://CIMod:
				transitionFilter = [[CIFilter filterWithName:@"CIModTransition"] retain];
				[transitionFilter setDefaults];
				[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
				break;
			
		case 15://CIPageCurl:
				transitionFilter =[ [CIFilter filterWithName:@"CIPageCurlTransition"] retain];
				[transitionFilter setDefaults];
				[transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
				[transitionFilter setValue:initialCIImage forKey:@"inputBacksideImage"];
				[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
				[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
				break;
		case 17://CISwipe:
			transitionFilter = [[CIFilter filterWithName:@"CISwipeTransition"] retain];
			[transitionFilter setDefaults];
			break;
		
		case 16://CIRipple:
			transitionFilter =[ [CIFilter filterWithName:@"CIRippleTransition"] retain];
			[transitionFilter setDefaults];
			[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
			[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
			[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
			break;
		default:
			
			break;
		
	}
	[transitionFilter setValue:initialCIImage forKey:@"inputImage"];
	[transitionFilter setValue:finalCIImage forKey:@"inputTargetImage"];
	//[initialCIImage release];
	//[finalCIImage release];
}
//===================new implement for QCRenderer Control
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

//=====================================================================================
//to generate the CoreImage Object here!
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
-(void) initOpenGL{
	NSOpenGLPixelFormatAttribute attributes[] ={
		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADepthSize,32,
		(NSOpenGLPixelFormatAttribute) 0
	};
	renderPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes]  ;
	renderOpenGLContext = [[NSOpenGLContext alloc] initWithFormat:renderPixelFormat shareContext:nil] ;
	long value = 1;

	[renderOpenGLContext setValues:&value
					  forParameter:kCGLCPSwapInterval];
	
	pixelsWidth = screenSize.width;
	pixelsHeight = screenSize.height;
	
	renderPixelBuffer = [[NSOpenGLPixelBuffer alloc] initWithTextureTarget:GL_TEXTURE_RECTANGLE_EXT
													 textureInternalFormat:GL_RGBA 
													 textureMaxMipMapLevel:0 
																pixelsWide:pixelsWidth
																pixelsHigh:pixelsHeight] ;
	
	
	[renderOpenGLContext setPixelBuffer:renderPixelBuffer
							cubeMapFace:0
							mipMapLevel:0
				   currentVirtualScreen:[renderOpenGLContext currentVirtualScreen]];
}
-(void) destroyOpenGL{
	[renderPixelFormat release];
	[renderOpenGLContext release];
	[renderPixelBuffer release];
}
@end
