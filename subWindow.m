//
//  subWindow.m
//  QuartzShow
//
//  Created by Tiger on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "subWindow.h"


@implementation subWindow
- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    NSWindow* result = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [result setBackgroundColor: [NSColor colorWithCalibratedWhite:0.5 alpha:1.0]];
    [result setOpaque:NO];	
    return result;
}

@end
