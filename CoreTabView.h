//
//  CoreTabView.h
//  QuartzShow
//
//  Created by Tiger on 3/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CGSPrivate.h"

@interface CoreTabView : NSTabView {
	CGSTransitionType CGSTransitionEffect;
	CGSTransitionOption CGSTransitionDirectionOption;
	CGSTransitionSpec   specifiedTransition;
	float				 TransitionDuration;
}
-(void) selectTabViewItem:(NSTabViewItem *)tabViewItem;
-(void) setCGSTransitionEffect:(CGSTransitionType) specifiedTransitionType;
-(void) setCGSTransitionOption:(CGSTransitionOption) specifiedTransitionOption;
-(void) setCGSTransitionDuration:(float) specifiedTransitionDuration;
@end
