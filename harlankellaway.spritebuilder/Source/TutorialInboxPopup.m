//
//  TutorialInboxPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialInboxPopup.h"

@implementation TutorialInboxPopup
{
     OALSimpleAudio *_audio;
}

- (void)didLoadFromCCB
{
    _audio = [OALSimpleAudio sharedInstance];
    self.visible = FALSE;
}

- (void)openPopup
{
    self.visible = TRUE;
    
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
    
    self.visible = FALSE;
    
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
