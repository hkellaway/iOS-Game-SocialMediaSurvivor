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

static const float STATUS_SCALE_FACTOR = 0.38;
static const float METER_SCALE_FACTOR = 1.0;

@implementation SocialMediaStatus
{
    CCButton *_recirculateButton;
    CCButton *_favoriteButton;
    CCButton *_blockButton;
    CCSprite *_meterBackground;
}

# pragma mark - initializers

- (void)didLoadFromCCB
{
    self.scaleX = self.scaleX * STATUS_SCALE_FACTOR;
    self.scaleY = self.scaleY * STATUS_SCALE_FACTOR;
    
    _meterBackground = _gameplay.meterBackground;
}

# pragma mark - button actions

// TODO: Do not duplicate button pressing functionality with each button press function

- (void)recirculate
{
    CCSprite *meterMiddle = _gameplay.meterMiddle;
    CCSprite *meterTop = _gameplay.meterTop;
    
    if(_actionType == ACTION_TYPE_RECIRCULATE)
    {
        meterMiddle.scaleY = meterMiddle.scaleY + METER_SCALE_FACTOR;
        
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y + (meterMiddle.contentSize.height * METER_SCALE_FACTOR));
    }
    else
    {
        meterMiddle.scaleY = meterMiddle.scaleY - METER_SCALE_FACTOR;
        
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y - (meterMiddle.contentSize.height * METER_SCALE_FACTOR));
    }
    
    [self disable];
}

- (void)favorite
{
    if(_actionType == ACTION_TYPE_FAVORITE)
    {
        CCSprite *meterMiddle = _gameplay.meterMiddle;
        CCSprite *meterTop = _gameplay.meterTop;
        
        meterMiddle.scaleY = meterMiddle.scaleY + METER_SCALE_FACTOR;
        
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y + (meterMiddle.contentSize.height * METER_SCALE_FACTOR));
    }
    
    [self disable];
}

# pragma mark - instance methods

- (void)checkState
{
    // if not disabled, check if status should have been recirculated/favorited
    if(_recirculateButton.enabled || _favoriteButton.enabled)
    {
        // if if should have been recirc/faved, scaled down
        if(self.actionType == ACTION_TYPE_RECIRCULATE || self.actionType == ACTION_TYPE_FAVORITE)
        {
            [self scaleMeter:(0)];
        }
    }
}

- (void)refresh
{
    int numStatuses = _gameplay.numStatuses;
    int spacing = _gameplay.statusSpacing;
    int newY = numStatuses * ((self.contentSize.height * self.scaleY) + spacing) - self.contentSize.height * self.scaleY/2;
    
    self.position = ccp(self.position.x, newY);
    self.isAtScreenBottom = FALSE;
    [self enable];
}

#pragma mark - helper methods

// if 0, scale down; if 1, scale up
- (void)scaleMeter:(int)scaleDirection
{
    CCSprite *meterMiddle = _gameplay.meterMiddle;
    CCSprite *meterTop = _gameplay.meterTop;
    
    float middleAmt = meterMiddle.scaleY + METER_SCALE_FACTOR;
    float topAmt = meterTop.position.y + (meterMiddle.contentSize.height * METER_SCALE_FACTOR);
    
    if(!scaleDirection)
    {
        meterMiddle.scaleY = meterMiddle.scaleY + middleAmt;
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y + topAmt);
    }
    else
    {
        meterMiddle.scaleY = meterMiddle.scaleY - middleAmt;
        meterTop.position = ccp(meterTop.position.x, meterTop.position.y - topAmt);
    }
}

- (void)disable
{
    _recirculateButton.enabled = FALSE;
    _favoriteButton.enabled = FALSE;
}

- (void)enable
{
    _recirculateButton.enabled = TRUE;
    _favoriteButton.enabled = TRUE;
}

@end
