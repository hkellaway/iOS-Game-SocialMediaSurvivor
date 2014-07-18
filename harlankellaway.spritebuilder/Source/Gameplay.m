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
#import "Trend.h"
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
    Level *_currentLevel;
    
    int numToRecirculate;
    int numToFavorite;
    NSTimer *timer;
}

- (void)didLoadFromCCB
{
    // initialize variables
    _numStatuses = NUM_STATUSES;
    _statusSpacing = 12;
    
    // clock
    _clock.gameplay = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:(TIMER_INTERVAL_IN_SECONDS)
                                                 target: self
                                               selector:@selector(onTimerFiring)
                                               userInfo: nil repeats: YES];
    
    // topics
    _allTopics = [NSMutableArray array];
    int numAllTopics;
    
    numToRecirculate = _numStatuses * PERCENTAGE_STATUS_TO_RECIRCULATE;
    numToFavorite = _numStatuses * PERCENTAGE_STATUS_TO_FAVORITE;
    _currentLevel.topicsToRecirculate = [[NSMutableArray alloc] init];
    _currentLevel.topicsToFavorite = [[NSMutableArray alloc] init];
    
    // level
    int currentLevelNum = [GameState sharedInstance].levelNum;
    _currentLevel = [[Level alloc] initWithLevelNum:currentLevelNum];
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // load Topics from p-list
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *plistXML = [self getPListXML:@"Topics"];
    
    // convert static property list into corresponding property-list objects
    // Topics p-list contains array of dictionarys
    NSArray *topicsArray = (NSArray *)[NSPropertyListSerialization
                                       propertyListFromData:plistXML
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                       format:&format
                                       errorDescription:&errorDesc];
    if(!topicsArray)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // TODO: DON'T LOAD IN ALL TOPICS EACH TIME GAMEPLAY LOADS
    for(int i = 0; i < [topicsArray count]; i++)
    {
        [_allTopics addObject:[(NSDictionary *)topicsArray[i] objectForKey:@"Noun"]];
    }
    
    numAllTopics = [_allTopics count];
    
    // get order recirculate/favorite/avoid for this set of Statuses
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:PERCENTAGE_STATUS_TO_RECIRCULATE percentToFavorite:PERCENTAGE_STATUS_TO_FAVORITE];
    
    // set topics to that are to be recirculated/favorited
    // add Trend objects to global GameState Topics array
    for(int j = 0; j < numToRecirculate; j++)
    {
        // get random topic
        NSString *randomTopic = [self getRandomTopic];
        
        // add to topics array
        [_currentLevel.topicsToRecirculate addObject:randomTopic];
        
        // create Trend and store in shared GameState
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend runAction:[CCActionRemove action]];          // TODO: REMOVE THIS HACKY FIX FOR COCOS2D 3.1 BUG
        [trend setTrendText:[NSString stringWithFormat:@"Recirculate statuses on %@", randomTopic]];
        [[GameState sharedInstance].trendsToRecirculate addObject:trend];
    }
    
    for(int k = 0; k < numToFavorite; k++)
    {
        NSString *randomTopic = [self getRandomTopic];
        
        [_currentLevel.topicsToFavorite addObject:randomTopic];
        
//        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
//        trend.trendText.string = [NSString stringWithFormat:@"Favorite statuses on %@", randomTopic];
//        [[GameState sharedInstance].trendsToFavorite addObject:trend];
    }
    
    // create SocialMediaStatus objects
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, ((i * height)) + _statusSpacing);
        
        if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", ACTION_TYPE_RECIRCULATE]])
        {
            status.actionType = ACTION_TYPE_RECIRCULATE;
            status.statusText.string = _currentLevel.topicsToRecirculate[0 + arc4random() % ([_currentLevel.topicsToRecirculate count])];
        }
        else if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", ACTION_TYPE_FAVORITE]])
        {
            status.actionType = ACTION_TYPE_FAVORITE;
            status.statusText.string = _currentLevel.topicsToFavorite[0 + arc4random() % ([_currentLevel.topicsToFavorite count])];
        }
        else
        {
            status.actionType = 0;
//            status.statusText.string = [NSString stringWithFormat:@"RANDOM"];
            status.statusText.string = [self getRandomTopic];
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

- (void)setTopics:(NSMutableArray *)topics
{
    _allTopics = [[NSMutableArray alloc] init];
}

- (void)update:(CCTime)delta
{
    // scrolling of SocialMediaStatues
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
        status.position = ccp(status.position.x, status.position.y - _currentLevel.streamSpeed);
        
        if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) * -1))
        {
            status.isAtScreenBottom = TRUE;
            CCLOG(@"In if! id = %d, postion.y = %f", i, status.position.y);
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
        [self gameOver];
    }
}

- (void)gameOver
{
    // stop timer
    [timer invalidate];
    timer = nil;
    
    // rese global values
    [GameState sharedInstance].levelNum = 1;
    
    _inbox.visible = TRUE;
    
    
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

- (NSString *)getRandomTopic
{
    return _allTopics[0 + arc4random() % ([_allTopics count])];
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
