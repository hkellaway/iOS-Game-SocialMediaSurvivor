//
//  Clock.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Clock.h"

static const int NUM_SECONDS_IN_LEVEL = 20;

@implementation Clock

- (void)didLoadFromCCB
{
    _numSecondsPerLevel = NUM_SECONDS_IN_LEVEL;
    
    _timeLeft.string = [NSString stringWithFormat:@"%d", NUM_SECONDS_IN_LEVEL];
}

@end
