//
//  Gameplay.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "SocialMediaStatus.h"

static const int NUM_STATUSES = 12;
static const int NUM_ACTION_STATES = 2;

static const int NUM_STATUS_OPTIONS = 5;

@implementation Gameplay
{
    CCSprite *_socialMediaStream;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    
    NSString *_statusTextOptions[NUM_STATUS_OPTIONS];
}

- (void)didLoadFromCCB
{
    // TODO: don't hardcode values
    CGFloat xPos = 128;
    CGFloat yStart = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = 44;
    CGFloat spacing = 12;
    
    
    // TODO: don't hardcode status options
    _statusTextOptions[0] = @"Buckets are so hilarious!";
    _statusTextOptions[1] = @"Most trees are blue..";
    _statusTextOptions[2] = @"Are snakes real?";
    _statusTextOptions[3] = @"Daft punk is dope.";
    _statusTextOptions[4] = @"I love straws";
    
    for(int i = 0; i < NUM_STATUSES; i++)
    {
//        SocialMediaStatus *status = _statuses[i];
//        status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        _statuses[i] = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        _statuses[i].position = ccp(xPos, (yStart - (i * height)) + spacing);
        
        _statuses[i].statusText.string = _statusTextOptions[0 + arc4random() % (NUM_STATUS_OPTIONS)];
        
        _statuses[i].actionType = 1 + arc4random() % (NUM_ACTION_STATES);
        
        CCLOG(@"status (xPosition, yPosition, actionType ) = (%f, %f, %d)", xPos, (yStart - (i * height)) + spacing, _statuses[i].actionType);
        
        [self addChild:_statuses[i]];
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
