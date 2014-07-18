//
//  Trend.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Trend.h"

@implementation Trend
{
    CCLabelTTF *_trendText;
}

- (void)setTrendText:(NSString *)text
{
    _trendText.string = text;
}

@end
