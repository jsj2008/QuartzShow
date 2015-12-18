//
//  operationController.m
//  QuartzShow
//
//  Created by Tiger on 2/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "operationController.h"
#import "renderController.h"
#import "preferenceWindowController.h"



@implementation operationController
-(NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication * )sender{
	[screenSaverShowController endShow];
	return NSTerminateNow;
}


-(void) applicationDidFinishLaunching:(NSNotification * ) aNotification{
//	printf("The application finish up its launching\n");
	
	
	aStatusBar = [NSStatusBar systemStatusBar];
	theItemInAStatusBar = [aStatusBar statusItemWithLength:NSVariableStatusItemLength];
	[theItemInAStatusBar retain];
	
	statusItemIcon = [NSImage imageNamed:@"MenuItem.png"];
	[theItemInAStatusBar setImage: statusItemIcon];
	//[theItemInAStatusBar setTitle:@"QuartzShow"];
	[theItemInAStatusBar setHighlightMode:YES];
	[theItemInAStatusBar setMenu:operationMenu];
	
//	screenSaverShowController = [[screenSaverShow alloc] init];
		
	executeController = [[renderController alloc] init];
	[executeController retain];
	[executeController initRendering:screenSaverShowController];
		
}

-(BOOL) application:(NSApplication *) theApplication openFile:(NSString *) fileName{

	
	[startORstopMenuItem setTitle:@"Stop Rendering"];
	[preferenceMenuItem setEnabled:YES];
	[executeController renderingFile:fileName];
	
	renderFileName = fileName;
	[renderFileName retain];
	[fileName release];
	
	return YES;
}
-(IBAction) showScreenSaver:(id) sender{
	[screenSaverShowController showSceenSaver:sender withObject:executeController ];
}

-(IBAction) openComposition:(id) sender{
	
	NSOpenPanel * fileOpenPanel;
	
	fileOpenPanel = [NSOpenPanel openPanel];
	[fileOpenPanel	setAllowsMultipleSelection:NO];
	[fileOpenPanel	setCanChooseDirectories:NO];
	[fileOpenPanel	setCanChooseFiles:YES];
	
	if ([fileOpenPanel	runModalForDirectory:NSHomeDirectory() 
						file:nil 
						types:[NSArray arrayWithObject:@"qtz"]]
						!= NSOKButton) {
		return;
	}
	
	renderFileName = [[[fileOpenPanel	filenames] objectAtIndex:0]	retain];

	
	[preferenceMenuItem setEnabled:YES];
//	[self closeParametersPanel];
	[executeController renderingFile:renderFileName];

}

-(IBAction) editComposition:(id) sender{
	BOOL result;
	NSString * tempFileName = [executeController getQCRendererName];
	if (tempFileName == nil) {
		return ;
	}
	result =[[NSWorkspace sharedWorkspace] openFile:tempFileName withApplication:@"Quartz Composer"];
	
	if (result == NO) {
		return;
	}
}

-(IBAction) openPreferencePanel:(id) sender{
	
	int statusCode = [screenSaverShowController statusCode];
	if (statusCode != 0) {
		return;
	}
	
	[self showParametersPanel:nil];
}

-(IBAction) showAboutPanel:(id) sender{
	
	[AboutWindow makeKeyAndOrderFront:nil];
}

-(IBAction) startORstopRendering:(id) sender{
//	printf("To pass message to Rendering Controller\n");
	NSString * statusString = [sender title];
	if ([statusString isEqualToString:@"Stop Rendering"]) {
		[executeController renderingStop];
		[sender setTitle:@"Start Rendering"];
		return;
	}
	
	if ([statusString isEqualToString:@"Start Rendering"]) {
		[executeController renderingStart];
		[sender setTitle:@"Stop Rendering"];
		return;
	}
	
		
}

-(IBAction) quitApplication:(id) sender{
	[screenSaverShowController endShow];
	[NSApp terminate:nil	];
}

-(float) getCurrentRenderingFPS{
	return [executeController getCurrentRenderingFPS];
} 

-(void) closeParametersPanel{
	[parametersPanel close];
}

-(IBAction) showParametersPanel:(id) sender{
	
	NSRect			frame = [parametersPanel frame];
	NSDictionary *	parameters;
	NSScrollView *	scrollView;
	float	height;

//Special Attention!	
	settingsView = [[CompositionParametersView alloc] initWithQCRenderer:[executeController getQCRenderer]];
	[settingsView getRenderingControl:executeController];
	
	scrollView = [[NSScrollView alloc] initWithFrame:NSZeroRect];
	[scrollView setDrawsBackground:NO];
	[scrollView setHasHorizontalScroller:NO];
	[scrollView setHasVerticalScroller:YES];
	[[scrollView verticalScroller] setControlSize:NSSmallControlSize];
	[scrollView setDocumentView:settingsView];
	[parametersPanel setContentView:scrollView];
	[scrollView release];
	
	parameters = [settingsView parameters:NO];
	[settingsView setFrameSize:[settingsView bestSize]];
	
	if ([settingsView bestSize].height + 20 > 400) {
		height = 400;
	}else {
		height = [settingsView bestSize].height +20;
	}

	
	
	frame.origin.y = frame.origin.y + frame.size.height -height;
	frame.size.width = [settingsView bestSize].width + 50;
	frame.size.height = height - 5;
	[parametersPanel setMinSize:NSMakeSize(frame.size.width, 80)];
	[parametersPanel	setMaxSize:NSMakeSize(frame.size.width,[settingsView bestSize].height +15)];
//	[parametersPanel setBackgroundColor:[NSColor whiteColor]];
	[parametersPanel setOpaque:NO];
	[parametersPanel setAlphaValue:0.9];
	[parametersPanel setFrame:frame display:YES];
	[settingsView setParameters:parameters];
	
	[parametersPanel orderFront:nil];
}

-(IBAction) showAnimationPreference:(id) sender{
	
	int statusCode = [screenSaverShowController statusCode];

	if (statusCode != 0) {
		return;
	}
	
	[controlWindow makeKeyAndOrderFront:sender];
}
-(QCRenderer  *) getQCRenderer{
	return [executeController getQCRenderer];
}
-(NSString *) getQCRendererName{
	return [executeController getQCRendererName];
}
@end
