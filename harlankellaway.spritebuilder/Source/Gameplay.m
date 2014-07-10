//
//  Gameplay.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "SocialMediaStatus.h"

static const int NUM_STATUSES = 9;

@implementation Gameplay
{
    CCSprite *_socialMediaStream;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
}

- (void)didLoadFromCCB
{
//    for(int i = 0; i < NUM_STATUSES; i++)
//    {
//        _statuses[i] = [[SocialMediaStatus alloc] initWithText:@"Hello World" andActionType:1];
//    }
//    
//    SocialMediaStatus *status1 = _statuses[0];
//    
//    status1.position = ccp(128, 284);
//    status1.visible = TRUE;
//    
//    [self addChild:status1];
    
    SocialMediaStatus *status1 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status1.position = ccp(128,568);
    
    [self addChild:status1];
    
    SocialMediaStatus *status2 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status2.position = ccp(128,500);
    
    [self addChild:status2];
    
    SocialMediaStatus *status3 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status3.position = ccp(128,432);
    
    [self addChild:status3];
    
    SocialMediaStatus *status4 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status4.position = ccp(128,364);
    
    [self addChild:status4];
    
    SocialMediaStatus *status5 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status5.position = ccp(128,296);
    
    [self addChild:status5];
    
    SocialMediaStatus *status6 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status6.position = ccp(128,228);
    
    [self addChild:status6];
    
    SocialMediaStatus *status7 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status7.position = ccp(128,160);
    
    [self addChild:status7];
    
    SocialMediaStatus *status8 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status8.position = ccp(128,92);
    
    [self addChild:status8];
    
    SocialMediaStatus *status9 = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
    status9.position = ccp(128,24);
    
    [self addChild:status9];
    
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)update:(CCTime)delta
{
    // TODO: scrolling functionality to be implemented here
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Made");
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Moved");
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the users drags their finger off the screen or onto something else
    CCLOG(@"Touch Cancelled");
}

@end
