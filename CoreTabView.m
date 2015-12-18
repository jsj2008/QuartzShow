//
//  CoreTabView.m
//  QuartzShow
//
//  Created by Tiger on 3/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CoreTabView.h"


@implementation CoreTabView
- (id) init {
	self = [super init];
	if (self != nil) {
		CGSTransitionEffect = CGSNone;
		CGSTransitionDirectionOption = CGSUp;
		TransitionDuration = 1.0;
	}
	return self;
}


-(void) selectTabViewItem:(NSTabViewItem *)tabViewItem{
	[super selectTabViewItem:tabViewItem];
	
	if (CGSTransitionEffect == CGSNone) {
		return ;
	}
	int handle = -1;
	specifiedTransition.unknown1 = 0;
	specifiedTransition.type = CGSTransitionEffect;
	specifiedTransition.option = CGSTransitionDirectionOption | (1<<7);
	specifiedTransition.backColour = NULL;
	specifiedTransition.wid = [[self window] windowNumber];
	
	CGSConnection cgsCon =  _CGSDefaultConnection();
	
	CGSNewTransition(cgsCon,
					 	&specifiedTransition,
					 &handle);
	[[self window] display];
	
	CGSInvokeTransition(cgsCon,
						handle,
						TransitionDuration);
	usleep((useconds_t) TransitionDuration * 1000000);
	CGSReleaseTransition(cgsCon, handle);
}

-(void) setCGSTransitionEffect:(CGSTransitionType) specifiedTransitionType{
	CGSTransitionEffect = specifiedTransitionType;
}
-(void) setCGSTransitionOption:(CGSTransitionOption) specifiedTransitionOption{
	CGSTransitionDirectionOption = specifiedTransitionOption;
}
-(void) setCGSTransitionDuration:(float) specifiedTransitionDuration{
	TransitionDuration = specifiedTransitionDuration;
}

@end
