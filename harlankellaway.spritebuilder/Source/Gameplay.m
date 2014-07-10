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
    // TODO: don't hardcode values
    CGFloat xPos = 128;
    CGFloat yStart = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = 68;
    CGFloat spacing = 12;
    
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
        status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        status.position = ccp(xPos, (yStart - (i * height)) + spacing);
        
        status.statusText = [NSString stringWithFormat:@"Hello World"];
        status.actionType = 2;
        
        [self addChild:status];
    }
    
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
