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
//static const int NUM_ACTION_STATES = 3;

@implementation Gameplay
{
    CCNode *_messageNotification;
    CCLabelTTF *_numMessagesLabel;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    Level *_currentLevel;
}

- (void)didLoadFromCCB
{
    _currentLevel = [[Level alloc] init];
//    [_levelNode addChild:_loadedLevel];
    
    _currentLevel.streamSpeed = 0;
//    NSMutableArray *topics = _currentLevel.topics;
//    NSMutableArray *statuses = _currentLevel.statuses;
    
    // TODO: don't hardcode values
    CGFloat xPos = 128;
    CGFloat yStart = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = 44;
    CGFloat spacing = 12;
    
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        status.gameplay = self;
        status.position = ccp(xPos, (yStart - (i * height)) + spacing);
        status.statusText.string = [_currentLevel getRandomStatus];
//        status.actionType = 0 + arc4random() % (NUM_ACTION_STATES);
        status.actionType = 1;
        
        CCLOG(@"Status #%d: (Text, actionType) = (%@, %d)", i, status.statusText.string, status.actionType);
        
        _statuses[i] = status;
        
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

# pragma mark - custom methods

- (void)checkMessages
{
    CCLOG(@"Message button pressed");
}

@end
