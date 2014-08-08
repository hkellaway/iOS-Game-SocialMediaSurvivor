//
//  Clock.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Clock.h"

//static const int NUM_SECONDS_IN_LEVEL = 30;

@implementation Clock
{
    CCLabelTTF *_timeLeftLabel;
}

- (void)setTimeLeft:(int)timeLeft
{
    _timeLeft = timeLeft;
    _timeLeftLabel.string = [NSString stringWithFormat:@"%d", timeLeft];
}

@end
