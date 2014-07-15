//
//  Gameplay.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "SocialMediaStatus.h"
#import "Level.h"

static const int NUM_STATUSES = 12;
static const int NUM_ACTION_STATES = 3;

@implementation Gameplay
{
    CCNode *_stream;
    CCNode *_messageNotification;
    CCLabelTTF *_numMessagesLabel;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    Level *_currentLevel;
}

- (void)didLoadFromCCB
{
    _currentLevel = [[Level alloc] init];
    
    _currentLevel.streamSpeed = 0;
    CGFloat yStart = [UIScreen mainScreen].bounds.size.height;
    CGFloat spacing = 12;
    
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        // TODO: don't hardcode xPos offset
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((status.contentSize.width * status.scaleX) / 2) + 31;
        
        status.position = ccp(xPos, (yStart - (i * height)) + spacing);
        status.statusText.string = [_currentLevel getRandomStatus];
        status.actionType = 0 + arc4random() % (NUM_ACTION_STATES);
        
        // set weak property
        status.gameplay = self;
        
        CCLOG(@"Status #%d: (Text, actionType) = (%@, %d)", i, status.statusText.string, status.actionType);
        
        _statuses[i] = status;
        
        [self addChild:_statuses[i]];
    }
    
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)update:(CCTime)delta
{
    // scrolling of SocialMediaStatues
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
//        status.position = ccp(status.position.x, status.position.y - 2.0);
    }
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

# pragma mark - custom methods

- (void)checkMessages
{
    CCLOG(@"Message button pressed");
}

@end
