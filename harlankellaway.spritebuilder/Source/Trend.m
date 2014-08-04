//
//  Trend.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Trend.h"
#import "CCTextureCache.h"

@implementation Trend
{
    CCSprite *_trendActionImage;
    CCLabelTTF *_trendText;
}

- (void)setTrendAction:(NSString *)actionImageName
{
    CCTexture* texture = [[CCTextureCache sharedTextureCache] addImage:actionImageName];
    [_trendActionImage setTexture: texture];
}

- (void)setTrendText:(NSString *)text
{
    _trendText.string = text;
}

@end
