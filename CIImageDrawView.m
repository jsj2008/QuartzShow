#import "CIImageDrawView.h"

@implementation CIImageDrawView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[forDrawImage drawInRect:rect
					fromRect:rect
				   operation:NSCompositeSourceOver
					fraction:1.0];
	
}

-(void) getCIImage:(CIImage*) drawImage{
	forDrawImage = drawImage ;
}


@end
