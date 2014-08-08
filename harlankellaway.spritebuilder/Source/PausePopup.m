//
//  PausePopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PausePopup.h"
#import "Utilities.h"

@implementation PausePopup
{
    CCAction *_easeInToCenter;
}

- (void)didLoadFromCCB
{
    _easeInToCenter = [CCActionMoveTo actionWithDuration:2.0 position:ccp(0.5,0.5)];
}

- (void)openPopup
{
    self.visible = TRUE;
    
//    [self runAction:_easeInToCenter];
    
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
    // reset volume
    [[Utilities sharedInstance] raiseVolume];
    
    
    // re-enable Inbeox button
    _gameplay.inboxButton.enabled = TRUE;
    
    self.visible = FALSE;
    
    [_gameplay resumeGame];
}

- (void)restart
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
