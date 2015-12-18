#import "CGSPrivate.h"
#define RenderStatusRendering 1
#define RenderStatusHalt 0


static void swizzleBitmap(void * data, int rowBytes, int height)
{
    int top, bottom;
    void * buffer;
    void * topP;
    void * bottomP;
    void * base;
	
    top = 0;
    bottom = height - 1;
    base = data;
    buffer = malloc(rowBytes);
	
    while ( top < bottom )
    {
        topP = (void *)((top * rowBytes) + (intptr_t)base);
        bottomP = (void *)((bottom * rowBytes) + (intptr_t)base);
		
		bcopy( topP, buffer, rowBytes );
		bcopy( bottomP, topP, rowBytes );
		bcopy( buffer, bottomP, rowBytes );
		
        ++top;
        --bottom;
    }
    free( buffer );
}


typedef enum {
	CGNone = 0,			// No transition effect.
	CGFade,				// Cross-fade.
	CGZoom,				// Zoom/fade towards us.
	CGReveal,				// Reveal new desktop under old.
	CGSlide,				// Slide old out and new in.
	CGWarpFade,			// Warp old and fade out revealing new.
	CGSwap,				// Swap desktops over graphically.
	CGCube,				// The well-known cube effect.
	CGWarpSwitch,			// Warp old, switch and un-warp.
	CGFlip,	// Flip over
	
	CICopyMachine,
	CIDisintegrate,
	CIDissolve,
	CIFlash,
	CIMod,
	CIPageCurl,
	CIRipple,
	CISwipe
	
	
} AnimationTransitionStyle;




static CGSTransitionOption directionTagToTransitionOption(int directionTag){
	switch (directionTag) {
		case 0: return CGSUp;
		case  1: return CGSDown;
		case  2:return CGSLeft;
		case  3: return CGSRight;
		case  4:return CGSTopLeft;
		case  5:return CGSBottomRight;
			
		case  6: return CGSTopRight;
		case  7:return CGSUpBottomRight;
		case  8:return CGSInBottom;
		case 9: return CGSLeftBottomRight;
		case  10:return CGSRightBottomLeft;
		case 11:return CGSInBottomRight;
		case  12:return CGSInOut;
		case 13:return CGSTopLeft;
			
	}
	return CGSUp ;
}
static CGSTransitionType tagToCGSTransitionType(int tag){
	switch (tag) {
		case 0:return CGSNone;
		case 1:return CGSFade;
		case  2:return CGSZoom;
		case 3:return CGSReveal;
		case  4:return CGSSlide;
		case 5:return CGSWarpFade;
		case 6:return CGSSwap;
		case 7:return CGSCube;
		case  8:return CGSWarpSwitch;
		case  9:return CGSFlip;
	}
	return CGSNone;
}

static AnimationTransitionStyle  tagToCoreImageTransitionType(int tag){
	switch (tag) {
		case 0:return CGNone;
		case 1:return CGFade;
		case  2:return CGZoom;
		case 3:return CGReveal;
		case  4:return CGSlide;
		case 5:return CGWarpFade;
		case 6:return CGSwap;
		case 7:return CGCube;
		case  8:return CGWarpSwitch;
		case  9:return CGFlip;
			
		case 10: return CICopyMachine;
		case 11:return CIDisintegrate;
		case 12: return CIDissolve;
		case 13:return CIFlash;
		case 14:return CIMod;
		case 15:return CIPageCurl;
		case 16:return CIRipple;
		case 17:return CISwipe;
			
		default:
			break;
	}	
}


