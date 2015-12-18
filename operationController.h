//
//  operationController.h
//  QuartzShow
//
//  Created by Tiger on 2/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <renderController.h>
#import <CompositionParametersView.h>
#import "preferenceWindowController.h"
#import "screenSaverShow.h"
#import "QCWraper.h"

@interface operationController : NSObject {
	IBOutlet	NSStatusBar  * aStatusBar;
	IBOutlet	NSStatusItem * theItemInAStatusBar;
				NSImage * statusItemIcon;
	IBOutlet	NSMenu	*  operationMenu;
	IBOutlet	NSWindow * controlWindow;
	IBOutlet	renderController * executeController;
	IBOutlet	NSApplication* FileSOwner;
				NSString * renderFileName;
	IBOutlet	NSMenuItem * preferenceMenuItem;
	IBOutlet	NSTextField	* maxFPS;
	IBOutlet	NSPanel *	parametersPanel;
	IBOutlet	NSMenuItem * startORstopMenuItem;
	IBOutlet	NSWindow * AboutWindow;
	IBOutlet	screenSaverShow * screenSaverShowController;
	
	CompositionParametersView * settingsView;
	

}
-(QCRenderer *) getQCRenderer;
-(NSString *) getQCRendererName;
-(void) closeParametersPanel;
-(IBAction) openComposition:(id) sender;
-(IBAction) editComposition:(id) sender;
-(IBAction) openPreferencePanel:(id) sender;
-(IBAction) showAboutPanel:(id) sender;
-(IBAction) startORstopRendering:(id) sender;
-(IBAction) quitApplication:(id) sender;
-(IBAction) showParametersPanel:(id) sender;
-(IBAction) showScreenSaver:(id) sender;
-(IBAction) showAnimationPreference:(id) sender;

@end
