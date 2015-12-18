/* CIImageDrawView */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CIImageDrawView : NSView
{
	CIImage * forDrawImage;
	CIContext * drawContext;
}
-(void) getCIImage:(CIImage*) drawImage;
@end
