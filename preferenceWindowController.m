#import "preferenceWindowController.h"
const int maxDurationValue = 5.0;
const int minDurationValue = 0.5;



@implementation preferenceWindowController
-(void) awakeFromNib{
	[directionSelect setMenu:blankMenu];
	[directionSelect setMenu:nil];
}
-(IBAction ) setAnimationType:(id) sender{
	outTag = [[sender cell] tag];
	printf("Your choice is %i\n",outTag);
	directionTag = 0;
	if (outTag == 7 || outTag == 9) {
		[directionSelect setMenu:fourTypeMenu];
		[directionSelect selectItemWithTag:directionTag];
	}else if (outTag == 3 || outTag == 4) {
		[directionSelect setMenu:sixTypeMenu];
		[directionSelect selectItemWithTag:directionTag];
	}else if (outTag == 6) {
		//set swap here
		[directionSelect setMenu:swapTypeMenu];
		[directionSelect selectItemWithTag:directionTag];
	}else {
	//	printf("Set Pop Up menu to nil\n");
		[directionSelect setMenu:blankMenu];
		[directionSelect setMenu:Nil];
	}
	[directionSelect display];

		
}
-(IBAction) setAnimationDuration:(id) sender{
	animationDuration = [sender floatValue];
	
}
-(void ) initialize{
	[durationSelect setMaxValue:maxDurationValue];
	[durationSelect setMinValue:minDurationValue];
	animationDuration = 1.0;
	[durationSelect setFloatValue:animationDuration];
	outTag = 1;
	[effectSelect selectItemWithTag:outTag];
	[directionSelect setMenu:nil];
}
-(float) animationDuration{
	return animationDuration;
}
-(int) animationEffect{
//	printf("To get the Animation Effect here %i\n",outTag);
	return outTag;
}
-(AnimationTransitionStyle) TagToTransitionType:( int)  tag{
	switch (tag) {
		case 0:	return CGNone;
		case 1:	return CGFade;
		case 2:  return CGZoom;
		case 3: return CGReveal;
		case 4:return CGSlide;
		case 5:return CGWarpFade;
		case  6:return CGSwap;
		case  7:return CGCube;
		case  8:return CGWarpSwitch;
		case 9:return CGFlip;

	}	
	//printf("You choose the CGSTransitionType!\n");
	return CGSNone;
}
-(IBAction) setAnimationDirection:(id)sender{
//	printf("You choose the AnimationType have %i directions\n",transitionTypeNumbers(outTag));
	directionTag = [[sender cell] tag];
	
}
-(int) animationDirection{
	return directionTag;
}

@end
