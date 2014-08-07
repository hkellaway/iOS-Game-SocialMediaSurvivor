//
//  TutorialMeterPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialMeterPopup.h"

@implementation TutorialMeterPopup
{
    OALSimpleAudio *_audio;
    CCAction *_easeInToCenter;
    CCAction *_easeToRight;
}

- (void)didLoadFromCCB
{
    _audio = [OALSimpleAudio sharedInstance];
    
    _easeInToCenter = [CCActionMoveTo actionWithDuration:2.0 position:ccp(0.5,0.5)];
    _easeToRight = [CCActionMoveTo actionWithDuration:2.0 position:ccp(1.5,0.5)];
}

- (void)openPopup
{
    [self runAction:_easeInToCenter];
    
    // if open, close Inbox
    if(_gameplay.inbox.visible)
    {
        [_gameplay.inbox toggleVisibility];
    }
    
    // disable Inbeox button
    _gameplay.inboxButton.enabled = FALSE;
    
    // lower volume
    [self lowerVolume];
    
    // pause game
    [_gameplay pauseGame];
}

- (void)closePopup
{
    // reset volume
    [self resetVolume];
    
    // re-enable Inbeox button
    _gameplay.inboxButton.enabled = TRUE;
    
    [self runAction:_easeToRight];
    
    [_gameplay resumeGame];
}

- (void)lowerVolume
{
    [_audio setBgVolume:[_audio bgVolume] / 2];
}

- (void)resetVolume
{
    [_audio setBgVolume:([_audio bgVolume] * 2)];
}

@end
