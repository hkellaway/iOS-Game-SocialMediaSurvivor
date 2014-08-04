//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"
#import "GameState.h"

static const int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;

static const float STATUS_SCALE_FACTOR = 0.47;
static const float METER_SCALE_FACTOR = 2;

static NSString *ANIMATION_FLASHING_NAME = @"FlashingAnimation";

@implementation SocialMediaStatus
{
    CCSprite *_meterBackground;
    
    CCAnimationManager *_recirculateAnimationManager;
    CCAnimationManager *_favoriteAnimationManager;
}

# pragma mark - initializers

- (void)didLoadFromCCB
{
    self.scaleX = self.scaleX * STATUS_SCALE_FACTOR;
    self.scaleY = self.scaleY * STATUS_SCALE_FACTOR;
    
    _meterBackground = _gameplay.meterBackground;

    _recirculateAnimationManager = _recirculateSprite.animationManager;
    _favoriteAnimationManager = _favoriteSprite.animationManager;
}

# pragma mark - button actions

// TODO: Do not duplicate button pressing functionality with each button press function

- (void)recirculate
{
    CCLOG(@"meter middle pos = %f", [[_gameplay.meterMiddle parent] convertToWorldSpace:_gameplay.meterMiddle.positionInPoints].y + (_gameplay.meterMiddle.contentSize.height * _gameplay.meterMiddle.scaleY));
    
    // scale up if correction action selected
    if (_actionType == ACTION_TYPE_RECIRCULATE)
    {
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:ACTION_TYPE_RECIRCULATE];
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
    else
    {
        if(_actionType == ACTION_TYPE_FAVORITE)
        {
            // flash correct action
            [self flashFavoriteButton];
        }
        
        // scale meter down
        [self scaleMeter:0];
    }
    
    // disable button
    _recirculateButton.enabled = FALSE;
    
    // remove background sprite so disabled button shows
    _recirculateSprite.visible = FALSE;
}

- (void)favorite
{
    // scale up if correction action selected
    if (_actionType == ACTION_TYPE_FAVORITE)
    {
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:ACTION_TYPE_FAVORITE];
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
    else
    {
         if(_actionType == ACTION_TYPE_RECIRCULATE)
         {
             // flash correct action
             [self flashRecirculateButton];
         }
        
        // scale meter down
        [self scaleMeter:0];
    }
    
    // disable button
    _favoriteButton.enabled = FALSE;
    
    // remove background sprite so disabled button shows
    _favoriteSprite.visible = FALSE;
}

# pragma mark - instance methods

- (void)checkState
{
    // if not disabled, check if status should have been recirculated/favorited
    if(_recirculateButton.enabled || _favoriteButton.enabled)
    {
        // if if should have been recirc/faved, scaled down
        if((self.actionType == ACTION_TYPE_RECIRCULATE && _recirculateButton.enabled) || (self.actionType == ACTION_TYPE_FAVORITE && _favoriteButton.enabled))
        {
            [self scaleMeter:(0)];
        }
    }
}

- (void)flashRecirculateButton
{
    [_recirculateAnimationManager runAnimationsForSequenceNamed:ANIMATION_FLASHING_NAME];
}
- (void)flashFavoriteButton
{
    [_favoriteAnimationManager runAnimationsForSequenceNamed:ANIMATION_FLASHING_NAME];
}

- (void)refresh
{
    int numStatuses = _gameplay.numStatuses;
    int spacing = _gameplay.statusSpacing;
    int newY = numStatuses * ((self.contentSize.height * self.scaleY) + spacing) - self.contentSize.height * self.scaleY/2;
    
    self.position = ccp(self.position.x, newY);
    _recirculateSprite.visible = TRUE;
    _favoriteSprite.visible = TRUE;
    self.isAtScreenBottom = FALSE;
    [self enable];
}

#pragma mark - helper methods

- (void)scaleMeter:(int)scaleDirection
{
    CCSprite *meterMiddle = _gameplay.meterMiddle;
//    CCSprite *meterTop = _gameplay.meterTop;
    
    // don't scale while game is over
    if(!_gameplay.isLevelOver)
    {
    
//    // if scaling down, check if meterMiddle is at origin
//    if(!scaleDirection)
//    {
//        // if scaling down while at origin, game is over
//        if(!meterMiddle.scaleY == 1)
//        {
//             //TODO:
//        }
//    }
    
    // scale down if 0, up if 1
    meterMiddle.scaleY = (scaleDirection ? meterMiddle.scaleY + METER_SCALE_FACTOR : meterMiddle.scaleY - METER_SCALE_FACTOR);
    
    // move top
//    meterTop.position = ccp(meterTop.position.x, (meterMiddle.position.y + (meterMiddle.contentSize.height * meterMiddle.scaleY)));
    }
    
}

- (void)enable
{
    _recirculateButton.enabled = TRUE;
    _favoriteButton.enabled = TRUE;
}

@end
