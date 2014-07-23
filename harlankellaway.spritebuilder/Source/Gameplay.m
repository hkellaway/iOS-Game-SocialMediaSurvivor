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
#import "Clock.h"
#import "Inbox.h"
#import "GameState.h"

// TODO: make this number larger than the largest amount that will fit on the tallest device
static const int NUM_STATUSES = 13;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;

static const int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;
static const int TIMER_INTERVAL_IN_SECONDS = 1;

@implementation Gameplay
{
    CCNode *_stream;
    Clock *_clock;
    CCNode *_messageNotification;
    CCLabelTTF *_numInboxNotifications;
    Inbox *_inbox;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    NSTimer *_timer;
    NSMutableArray *_topicsToRecirculate;
    NSMutableArray *_topicsToFavorite;
}

- (void)didLoadFromCCB
{
    // initialize variables
    _numStatuses = NUM_STATUSES;
    _statusSpacing = 4;
    
    // clock
    _clock.gameplay = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:(TIMER_INTERVAL_IN_SECONDS)
                                                 target: self
                                               selector:@selector(onTimerFiring)
                                               userInfo: nil repeats: YES];
    
    // inbox
    _inbox.gameplay = self;
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // get order recirculate/favorite/avoid for this set of Statuses
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:PERCENTAGE_STATUS_TO_RECIRCULATE percentToFavorite:PERCENTAGE_STATUS_TO_FAVORITE];
    
    // create SocialMediaStatus objects
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, (i*(height + _statusSpacing)) + height/2);
        
        if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", ACTION_TYPE_RECIRCULATE]])
        {
            status.actionType = ACTION_TYPE_RECIRCULATE;
            
            _topicsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
            
            status.statusText.string = _topicsToRecirculate[0 + arc4random() % ([_topicsToRecirculate count])];
        }
        else if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", ACTION_TYPE_FAVORITE]])
        {
            status.actionType = ACTION_TYPE_FAVORITE;
            
            _topicsToFavorite = [GameState sharedInstance].trendsToFavorite;
            
            status.statusText.string = _topicsToFavorite[0 + arc4random() % ([_topicsToFavorite count])];
        }
        else
        {
            status.actionType = 0;
            
            NSMutableArray *allTopics = [GameState sharedInstance].allTopics;
            status.statusText.string = allTopics[0 + arc4random() % ([allTopics count])];
        }
            
        status.isAtScreenBottom = FALSE;
        
        // set weak property(s)
        status.gameplay = self;
        
        _statuses[i] = status;
        
        [_stream addChild:status];
    }
    
    
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)update:(CCTime)delta
{
    // scrolling of SocialMediaStatues
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
        //status.position = ccp(status.position.x, status.position.y - _currentLevel.streamSpeed);
        
        status.position = ccp(status.position.x, status.position.y - [GameState sharedInstance].streamSpeed);
        
        if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) * -1))
        {
            status.isAtScreenBottom = TRUE;
            
            // if status is not disabled and should have been Recir/Faved, decrease Meter
            [status checkState];
            
            // change topic, move to top, etc.
            [status refresh];
        }
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

- (void)checkInbox
{
    CCLOG(@"Message button pressed");
    
    [_inbox toggleVisibility];
}

-(void)onTimerFiring
{
    int newTime =  _clock.timeLeft.string.intValue - TIMER_INTERVAL_IN_SECONDS;
    
    _clock.timeLeft.string = [NSString stringWithFormat:@"%d", newTime];
    
    if(newTime == 0)
    {
        CCLOG(@"Round over!");
        [self gameOver];
    }
}

- (void)gameOver
{
    // stop timer
    [_timer invalidate];
    _timer = nil;
    
    // reset global values
    [GameState sharedInstance].levelNum = 1;
    [GameState sharedInstance].trendsToRecirculate = nil;
    [GameState sharedInstance].trendsToFavorite = nil;
    
    // load GameOver scene
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

# pragma mark - helper methods

- (NSData *)getPListXML: (NSString *)pListName
{
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // get file-styem path to file containing XML property list
    plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", pListName]];
    
    // if file doesn't exist at file-system path, check application's main bundle
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", pListName] ofType:@"plist"];
    }
    
    return [[NSFileManager defaultManager] contentsAtPath:plistPath];
}

- (NSMutableArray *)getRandomActionTypes:(int)numStatuses
                         percentToRecirculate:(CGFloat)percentToRecirculate
                            percentToFavorite:(CGFloat)percentToFavorite
{
    NSMutableArray *statuses = [[NSMutableArray alloc] initWithCapacity:numStatuses];
    double recirculatedCounter = floor(numStatuses * percentToRecirculate);
    double favoritedCounter = floor(numStatuses * percentToFavorite);
    
    for(int i = 0; i < numStatuses; i++)
    {
        if(recirculatedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"%d", ACTION_TYPE_RECIRCULATE];
            recirculatedCounter--;
        }
        else if(favoritedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"%d", ACTION_TYPE_FAVORITE];
            favoritedCounter--;
        }
        else
        {
            statuses[i] = [NSString stringWithFormat:@"%d", 0];
        }
    }

    // shuffle order
    for(int i = 0; i < numStatuses; i++)
    {
        NSInteger remainingCount = numStatuses - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [statuses exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return statuses;
}

@end
