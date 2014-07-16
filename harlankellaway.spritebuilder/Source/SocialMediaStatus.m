//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"

static const int ACTION_TYPE_RECIRCULATE = 1;
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
        
        meterMiddle.scaleY = meterMiddle.scaleY + meterMiddleGrowth;
        
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y + (meterMiddleGrowth / meterMiddle.contentSize.height));
        
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
    // move to above last status in line
//    self.position = ccp(self.position.x, [CCDirector sharedDirector].viewSize.height + (self.contentSize.height * self.scaleY) / 2);

    int numStatuses = 10;
    int spacing = 12;
    int newY = numStatuses * ((self.contentSize.height * self.scaleY) + spacing);
    
    self.position = ccp(self.position.x, newY);
    self.isAtScreenBottom = FALSE;
}

#pragma mark - helper methods

@end
