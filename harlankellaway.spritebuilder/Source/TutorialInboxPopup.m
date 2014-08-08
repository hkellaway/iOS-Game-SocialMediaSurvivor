//
//  TutorialInboxPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialInboxPopup.h"
#import "Utilities.h"

@implementation TutorialInboxPopup
{
    CCAction *_easeInToCenter;
    CCAction *_easeToRight;
}

- (void)didLoadFromCCB
{
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
    [[Utilities sharedInstance] lowerVolume];
}

- (void)closePopup
{
    // move popup offscreen
    [self runAction:_easeToRight];
    
    // if game is not paused, unpause the game
    if(!_gameplay.isPaused)
    {
        // reset volume
        [[Utilities sharedInstance] raiseVolume];
        
        // re-enable Inbeox button
        _gameplay.inboxButton.enabled = TRUE;
        
        [_gameplay resumeGame];
    }
}

@end
