//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"

static const  int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;
static const int ACTION_TYPE_BLOCK = 3;

static const float SCALE_FACTOR = 0.4;

@implementation SocialMediaStatus
{
    CCSprite *_avatar;
    CCButton *_recirculateButton;
    CCButton *_favoriteButton;
    CCButton *_blockButton;
}

# pragma mark - initializers

- (void)didLoadFromCCB
{
    self.scaleX = self.scaleX * SCALE_FACTOR;
    self.scaleY = self.scaleY * SCALE_FACTOR;
}

# pragma mark - button actions

- (void)recirculate
{
    CCLOG(@"Recirculate button pressed");
    
    if(_actionType == ACTION_TYPE_RECIRCULATE)
    {
        CCLOG(@"Yay!");
    }
}

- (void)favorite
{
    CCLOG(@"Favorite button pressed");
    
    if(_actionType == ACTION_TYPE_FAVORITE)
    {
        CCLOG(@"Yay!");
    }
}

- (void)block
{
    CCLOG(@"Block button pressed");
    
    if(_actionType == ACTION_TYPE_BLOCK)
    {
        CCLOG(@"Yay!");
    }
}

@end
