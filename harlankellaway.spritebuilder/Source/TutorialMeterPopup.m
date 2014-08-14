//
//  TutorialMeterPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialMeterPopup.h"
#import "Utilities.h"

@implementation TutorialMeterPopup
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
    
    // disable buttons
    _gameplay.inboxButton.enabled = FALSE;
    _gameplay.pauseButton.enabled = FALSE;
    
    // lower volume
    [[Utilities sharedInstance] lowerVolume];
}

- (void)closePopup
{
    [self runAction:_easeToRight];
    
    if(!_gameplay.isPaused)
    {
        // reset volume
        [[Utilities sharedInstance] raiseVolume];
    
        // re-enable buttons
        _gameplay.inboxButton.enabled = TRUE;
        _gameplay.pauseButton.enabled = TRUE;
        
        [_gameplay resumeGame];
    }
}

@end
