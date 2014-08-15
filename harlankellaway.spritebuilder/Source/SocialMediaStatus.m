//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"
#import "GameState.h"
#import "Utilities.h"

static const float STATUS_SCALE_FACTOR = 0.32;
static const float METER_SCALE_FACTOR_UP = 0.25;
static const float METER_SCALE_FACTOR_DOWN = 2.0;

static NSString *ANIMATION_FLASHING_NAME = @"FlashingAnimation";

@implementation SocialMediaStatus
{
    CCSprite *_meterBackground;
    
    int _actionTypeRecirculate;
    int _actionTypeFavorite;
    
    CCAnimationManager *_recirculateAnimationManager;
    CCAnimationManager *_favoriteAnimationManager;
}

# pragma mark - initializers

- (void)didLoadFromCCB
{
    self.isAtScreenBottom = FALSE;
    self.hasFlashedBeforeExitingScreen = FALSE;
    
    self.scaleX = self.scaleX * STATUS_SCALE_FACTOR;
    self.scaleY = self.scaleY * STATUS_SCALE_FACTOR;
    
    _meterBackground = _gameplay.meterBackground;
    
    _actionTypeRecirculate = [GameState sharedInstance].actionTypeRecirculate;
    _actionTypeFavorite = [GameState sharedInstance].actionTypeFavorite;

    _recirculateAnimationManager = _recirculateSprite.animationManager;
    _favoriteAnimationManager = _favoriteSprite.animationManager;
}

# pragma mark - button actions

// TODO: Do not duplicate button pressing functionality with each button press function

- (void)recirculate
{
    // scale up if correction action selected
    if (_actionType == _actionTypeRecirculate)
    {
        // play sound
        [[Utilities sharedInstance] playSoundCorrect];
        
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:_actionTypeRecirculate];
    }
    else
    {
        // play sound
        [[Utilities sharedInstance] playSoundIncorrect];
        
        if(_actionType == _actionTypeFavorite)
        {
            // flash correct action
            [self flashFavoriteButton];
        }
        
        // scale meter down
        [self scaleMeter:0];
        [_gameplay decrementStatusHandledCorrectlyOfActionType:_actionTypeRecirculate];
    }
    
    // disable button
    _recirculateButton.enabled = FALSE;
    
    // remove background sprite so disabled button shows
    _recirculateSprite.visible = FALSE;
}

- (void)favorite
{
    // scale up if correction action selected
    if (_actionType == _actionTypeFavorite)
    {
        // play sound
        [[Utilities sharedInstance] playSoundCorrect];
        
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:_actionTypeFavorite];
    }
    else
    {
        // play sound
        [[Utilities sharedInstance] playSoundIncorrect];
        
         if(_actionType == _actionTypeRecirculate)
         {
             // flash correct action
             [self flashRecirculateButton];
         }
        
        // scale meter down
        [self scaleMeter:0];
        [_gameplay decrementStatusHandledCorrectlyOfActionType:_actionTypeFavorite];
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
        if((self.actionType == _actionTypeRecirculate && _recirculateButton.enabled) || (self.actionType == _actionTypeFavorite && _favoriteButton.enabled))
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
    _recirculateSprite.visible = TRUE;
    _favoriteSprite.visible = TRUE;
    self.isAtScreenBottom = FALSE;
    [self enable];
}

- (void)flashRecirculateButton
{
    [_recirculateAnimationManager runAnimationsForSequenceNamed:ANIMATION_FLASHING_NAME];
}
- (void)flashFavoriteButton
{
    [_favoriteAnimationManager runAnimationsForSequenceNamed:ANIMATION_FLASHING_NAME];
}

#pragma mark - helper methods

- (void)scaleMeter:(int)scaleDirection
{
    CCSprite *meterMiddle = _gameplay.meterMiddle;
    
    // don't scale while game is over
    if(!_gameplay.isLevelOver)
    {
    
    // scale down if 0, up if 1
    meterMiddle.scaleY = (scaleDirection ? meterMiddle.scaleY + METER_SCALE_FACTOR_UP : meterMiddle.scaleY - METER_SCALE_FACTOR_DOWN);
    }
    
}

- (void)enable
{
    _recirculateButton.enabled = TRUE;
    _favoriteButton.enabled = TRUE;
}

@end
