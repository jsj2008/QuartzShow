#import "screenSaverShow.h"

@implementation screenSaverShow

- (id) init {
	self = [super init];
	if (self != nil) {
		path = @"/System/Library/Screen Savers";
		fileManager = [NSFileManager defaultManager];
		dirEum = [fileManager enumeratorAtPath:path];
		fileArray = [[NSMutableArray alloc] init];
		int i = 0;
		while ((path = [dirEum nextObject] ) != nil) {
			path = [path lastPathComponent];
			if ([[path lowercaseString]hasSuffix:@"qtz"] == YES) {
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]  );
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}else if ([[path lowercaseString]hasSuffix:@"saver"] == YES) {
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]);
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}else if([[path lowercaseString] hasSuffix:@"slidesaver"  ] == YES)			
			{
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]);
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}
		}
		path = @"/Users/Tiger/Library/Screen Savers";
		dirEum = [fileManager enumeratorAtPath:path];
		while ((path = [dirEum nextObject] ) != nil) {
			path = [path lastPathComponent];
			if ([[path lowercaseString]hasSuffix:@"qtz"] == YES) {
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]  );
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}else if ([[path lowercaseString]hasSuffix:@"saver"] == YES) {
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]);
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}else if([[path lowercaseString] hasSuffix:@"slidesaver"  ] == YES)			
			{
			//	printf("%s\n",[[path stringByDeletingPathExtension]cString]);
				[fileArray insertObject:[path stringByDeletingPathExtension] atIndex:i];
				i++;
				
			}
		}
	}
	return self;
}


- (IBAction)continueORpause:(id)sender
{
	
	NSString * taskTitle = [sender title];
	if ([taskTitle isEqualToString:@"Pause"]) {
		if (task == nil) {
			return;
		}
		BOOL running = [task isRunning];
		if (running == YES) {
			[task suspend];
		}
		statusCode =2;
		[sender setTitle:@"Continue"];
	}else if ([taskTitle isEqualToString:@"Continue"]) {
		if (task != nil) {
			[task resume];
		}
		statusCode = 3;
		[sender setTitle:@"Pause"];
	}
		
}

-(void) showSceenSaver:(id) sender withObject:(id) plugIn{
	[listWindow makeKeyAndOrderFront:nil];
	renderControl = plugIn;
	
}

- (IBAction)startORterminate:(id)sender
{	
	NSString* taskTitle = [sender title];
	
	//printf("Begin start or terminate\n");
	if ([taskTitle isEqualToString:@"Run"]) {
		[sender setTitle:@"End"];
		NSString * saverName;
		int selectedRow = [screensaverList selectedRow];
		saverName = [fileArray objectAtIndex:selectedRow];
	//	printf("Finish at the Saver Name\n");
				
	//	printf("Just going to launch the task\n");
		[renderControl renderingStop];
		NSArray *args = [NSArray arrayWithObjects:@"-background", @"-module", saverName,nil];
		task =[NSTask launchedTaskWithLaunchPath:@"/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine" 
									   arguments:args] ;
		
		[pauseOrContinue setTitle:@"Pause"];
		[pauseOrContinue setEnabled:YES];
		statusCode =1;
		
	}else if ([taskTitle isEqualToString:@"End"]) {
		[sender  setTitle:@"Run"];
	
		
		if (statusCode == 2) {
			[task resume];
			statusCode = 3;
		}
	
			[task terminate];
		
		[pauseOrContinue setTitle:@"Pause"];
		[pauseOrContinue setEnabled:NO];
		statusCode = 0;
		
	}
//	printf("Finishing start or terminate\n");
			
}

-(int) numberOfRowsInTableView:(NSTabView * ) myTableView{
	return [fileArray count];
}

-(id) tableView:(NSTableView * ) myTableView
objectValueForTableColumn:(NSTableColumn *) tableColumn
			row:(int) row{
	return [fileArray objectAtIndex:row];
}

-(void) endShow{
//	printf("In the ScreenSaverShow endShowMethod\n");
	if (task == nil) {
		return;
	}

	if (statusCode ==2) {
		[task resume];
	}
	if (statusCode == 0) {
		return;
	}
	[task terminate];
	statusCode =0;
	[pauseOrContinue setTitle:@"Pause"];
	[pauseOrContinue setEnabled:NO];
	[startORterminate setTitle:@"Run"];
//	printf("finish the EndShow method\n");
	

}
-(int) statusCode{
	return statusCode;
}

-(void) awakeFromNib{
	statusCode = 0;
	//printf("The Status code is %i\n",statusCode);
}

@end
