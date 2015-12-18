/* screenSaverShow */

#import <Cocoa/Cocoa.h>
#import "renderController.h"

@interface screenSaverShow : NSObject
{
    IBOutlet id screensaverList;
	IBOutlet id listWindow;
	IBOutlet id pauseOrContinue;
	IBOutlet id startORterminate;
	id renderControl;
	NSFileManager * fileManager;
	NSDirectoryEnumerator * dirEum;
	NSString * path;
	NSMutableArray *  fileArray;
	NSTask * task;
	int statusCode;
}
- (IBAction)continueORpause:(id)sender;
- (IBAction)startORterminate:(id)sender;
-(int) statusCode;
-(void) showSceenSaver:(id) sender withObject:(id) plugIn;
-(void) endShow;
@end
