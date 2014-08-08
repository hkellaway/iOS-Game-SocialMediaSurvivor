//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"
#import "GameState.h"

static const float STATUS_SCALE_FACTOR = 0.47;
static const float METER_SCALE_FACTOR = 1;

static NSString *ANIMATION_FLASHING_NAME = @"FlashingAnimation";

@implementation SocialMediaStatus
{
    CCSprite *_meterBackground;
    
    int _actionTypeRecirculate;
    int _actionTypeFavorite;
    
    CCAnimationManager *_recirculateAnimationManager;
    CCAnimationManager *_favoriteAnimationManager;
    
    OALSimpleAudio *_audio;
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
    
    _audio = [OALSimpleAudio sharedInstance];
}

# pragma mark - button actions

// TODO: Do not duplicate button pressing functionality with each button press function

- (void)recirculate
{
    // scale up if correction action selected
    if (_actionType == _actionTypeRecirculate)
    {
        // play sound
        [_audio playEffect:@"Audio/zapThreeToneUp.wav" volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
        
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:_actionTypeRecirculate];
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
    else
    {
        // play sound
        [_audio playEffect:@"Audio/zapThreeToneDown.wav" volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
        
        if(_actionType == _actionTypeFavorite)
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
    if (_actionType == _actionTypeFavorite)
    {
        // play sound
        [_audio playEffect:@"Audio/zapThreeToneUp.wav" volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
        
        [self scaleMeter:1];
        [_gameplay incrementStatusHandledCorrectlyOfActionType:_actionTypeFavorite];
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
    else
    {
        // play sound
        [_audio playEffect:@"Audio/zapThreeToneDown.wav" volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
        
         if(_actionType == _actionTypeRecirculate)
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
    meterMiddle.scaleY = (scaleDirection ? meterMiddle.scaleY + METER_SCALE_FACTOR : meterMiddle.scaleY - METER_SCALE_FACTOR);
    }
    
}

- (void)enable
{
    _recirculateButton.enabled = TRUE;
    _favoriteButton.enabled = TRUE;
}

@end
