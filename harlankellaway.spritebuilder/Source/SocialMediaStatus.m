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

static const float SCALE_FACTOR = 0.38;

@implementation SocialMediaStatus
{
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

// TODO: Do not duplicate button pressing functionality with each button press function

- (void)recirculate
{
    CCLOG(@"Recirculate button pressed");
    
    if(_actionType == ACTION_TYPE_RECIRCULATE)
    {
        CCLOG(@"Yay!");
        
        CCSprite *meterMiddle = _gameplay.meterMiddle;
        CCSprite *meterTop = _gameplay.meterTop;
        
        // TODO: calculate scale factor
        CGFloat scaleFactor = 0.25;
        CGFloat meterMiddleGrowth = meterMiddle.contentSize.height * scaleFactor;
        
        CCLOG(@"meterMiddle pos before = (%f, %f)", meterMiddle.position.x, meterMiddle.position.y);
        
        meterMiddle.scaleY = meterMiddle.scaleY + meterMiddleGrowth;
        
        CCLOG(@"meterMiddle pos after = (%f, %f)", meterMiddle.position.x, meterMiddle.position.y);
        
        CCLOG(@"meterTop pos before = (%f, %f)", meterTop.position.x, meterTop.position.y);
        
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y + (meterMiddleGrowth / meterMiddle.contentSize.height));
        
        CCLOG(@"meterTop pos after = (%f, %f)", meterTop.position.x, meterTop.position.y);
        
        CCLOG(@"Scaling attempt complete");
        
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

# pragma mark - instance methods

- (void)refresh
{
    CCLOG(@"Entering refresh method!");
    self.visible = FALSE;
}

#pragma mark - helper methods

@end
