//
//  CustomAnimation.m
//  QuartzShow
//
//  Created by Tiger on 3/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CustomAnimation.h"


@implementation CustomAnimation
- (void)setCurrentProgress:(NSAnimationProgress)progress {
	
    [super setCurrentProgress:progress];
    [[self delegate] drawCIImage];
}

@end