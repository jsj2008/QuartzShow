/* preferenceWindowController */

#import <Cocoa/Cocoa.h>
#import "CGSPrivate.h"
#import "PreDefine.h"

int outTag;
int directionTag;
float animationDuration;


@interface preferenceWindowController : NSObject
{
	//IBOutlet	NSWindow * targetWindow;
	IBOutlet NSPopUpButton * effectSelect;
	IBOutlet NSPopUpButton * directionSelect;
	IBOutlet NSSlider * durationSelect;
	IBOutlet NSMenu * fourTypeMenu;
	IBOutlet NSMenu * sixTypeMenu;
	IBOutlet NSMenu * swapTypeMenu;
	IBOutlet NSMenu * blankMenu;
	
	
}

-(IBAction) setAnimationType:(id) sender;
-(IBAction) setAnimationDuration:(id) sender;
-(IBAction) setAnimationDirection:(id) sender;

//-(AnimatingTabViewTransitionStyle) TagToTransitionType:( int)  tag;
//-(void ) initialize;
-(float) animationDuration;
-(int) animationEffect;
-(int) animationDirection;

-(void ) initialize;

@end

static int transitionTypeNumbers( int tag){
	if (tag == 7 || tag == 9) {
		return 4;// cube and flip
	}
	if (tag == 3 || tag == 4) {
		return 6;// reveal and slide
	}
	if (tag == 6) {
		return 8; //swap
	}
	return -1;
}
