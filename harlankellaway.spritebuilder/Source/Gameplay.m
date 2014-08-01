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
#import "LevelOverPopup.h"
#import "Popup.h"

// TODO: make this number larger than the largest amount that will fit on the tallest device
static const int NUM_STATUSES = 13;

static const CGFloat MAX_NUM_LEVELS = 10;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;

static const int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;
static const int TIMER_INTERVAL_IN_SECONDS = 1;

@implementation Gameplay
{
    // declared in SpriteBuilder
    CCNode *_stream;
    Clock *_clock;
    CCNode *_messageNotification;
    CCLabelTTF *_numInboxNotifications;
    Inbox *_inbox;
    LevelOverPopup *_levelOverPopup;
    Popup *_tutorialMeterPopup;
    
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
//    NSTimer *_timer;
    NSMutableArray *_topicsToRecirculate;
    NSMutableArray *_topicsToFavorite;
    Level *_currentLevel;
    
    int numRecirculatedCorrectly;
    int numFavoritedCorrectly;
    BOOL updateRankForLevel;
    
    NSDate *_timeSinceTimerBegan;
    int _timePaused;
    NSDate *_fireDatePaused;
    
    //
    NSTimer *timer;
    int timerInterval;
    double timerElapsed;
    NSDate *timerStarted;
}

- (void)didLoadFromCCB
{
    if([GameState sharedInstance].levelNum > MAX_NUM_LEVELS)
    {
        [self gameOver];
    }
    
    // TODO: implement Timer pausing
    timerInterval = TIMER_INTERVAL_IN_SECONDS;
    timerElapsed = 0.0;
    
    // initialize variables
    _numStatuses = NUM_STATUSES;
    _statusSpacing = 4;
    
    // clock
    _clock.gameplay = self;
    _timeSinceTimerBegan = nil;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:(TIMER_INTERVAL_IN_SECONDS)
//                                                 target: self
//                                               selector:@selector(onTimerFiring)
//                                               userInfo: nil repeats: YES];
    
    // level
    _isLevelOver = FALSE;
    _currentLevel = [[Level alloc] initWithLevelNum:[GameState sharedInstance].levelNum];
    [[GameState sharedInstance] setStreamSpeed:_currentLevel.streamSpeed];
    _levelOverPopup.gameplay = self;
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // get order recirculate/favorite/avoid for this set of Statuses
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:PERCENTAGE_STATUS_TO_RECIRCULATE percentToFavorite:PERCENTAGE_STATUS_TO_FAVORITE];
    
    // statuses
    numRecirculatedCorrectly = 0;
    numFavoritedCorrectly = 0;
    
    // rank
    updateRankForLevel = TRUE; // set so rank is updated first round
    
    // meter
    _meterMiddle.scaleY = [GameState sharedInstance].meterScale;
    _meterTop.position = ccp(_meterTop.position.x, (_meterMiddle.position.y + (_meterMiddle.contentSize.height * _meterMiddle.scaleY)));
    
    // popups
    _tutorialMeterPopup.gameplay = self;
    
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
    
    // TODO: start timer
    [self startTimer];
}

- (void)update:(CCTime)delta
{
    // scrolling of SocialMediaStatues
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
        status.position = ccp(status.position.x, status.position.y - [GameState sharedInstance].streamSpeed);
        
        if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) * -1))
        {
            status.isAtScreenBottom = TRUE;
            
            float meterMiddleStart = _meterMiddle.scaleY;
            
            // if status is not disabled and should have been Recir/Faved, decrease Meter
            [status checkState];
            
            float meterMiddleScaled = _meterMiddle.scaleY;
            
            // if meter scaling resulted in scale hitting 1.0, game is over
            if(meterMiddleStart <= 1.0 & meterMiddleScaled <= 1.0)
            {
                [self gameOver];
            }
            
            // change topic, move to top, etc.
            [status refresh];
        }
    }
    
    float middleHeight = (_meterMiddle.contentSize.height * _meterMiddle.scaleY) + (_meterTop.contentSize.height * _meterTop.scaleY);
    float backgroundHeight = _meterBackground.contentSize.height;
    
    // if meter scaling resulted in scale hitting the top, increase player rank
    if(middleHeight >= backgroundHeight)
    {
        [self increaseRank];
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

# pragma mark - Instance Methods

- (void)incrementStatusHandledCorrectlyOfActionType:(int)actionType
{
    if(actionType == ACTION_TYPE_RECIRCULATE)
    {
        numRecirculatedCorrectly++;
    }
    
    if(actionType == ACTION_TYPE_FAVORITE)
    {
        numFavoritedCorrectly++;
    }
}

- (void)gameOver
{
    [self stopTimer];
    
    // reset global values
    [[GameState sharedInstance] clearGameState];
    
    // load GameOver scene
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

# pragma mark - Custom Methods

-(void)onTimerFiring
{
    // start counting in order to pause
    if(_clock.timeLeft.string.intValue == _clock.numSecondsPerLevel)
    {
        _timeSinceTimerBegan = [[NSDate alloc] initWithTimeIntervalSinceNow: 0];
    }
    
    int newTime =  _clock.timeLeft.string.intValue - TIMER_INTERVAL_IN_SECONDS;
    
    _clock.timeLeft.string = [NSString stringWithFormat:@"%d", newTime];
    
    // trigger tutorial in if not completed yet
    if((_currentLevel.levelNum == 1) && (newTime == (_clock.numSecondsPerLevel - 5)) && ([GameState sharedInstance].isTutorialComplete == FALSE))
    {
        _tutorialMeterPopup.visible = TRUE;
    }
    
    if(newTime == 0)
    {
        [self levelOver];
    }
}

- (void)checkInbox
{
    [_inbox toggleVisibility];
}

- (void)increaseRank
{
    CCLOG(@"Rank Increased!");
    
    // set flag
    updateRankForLevel = TRUE;
    
    // save increased rank to GameState
    [[GameState sharedInstance] setPlayerRank:([GameState sharedInstance].playerRank + 1)];
    
    // reset meter height
    _meterMiddle.scaleY = [GameState sharedInstance].meterScaleOriginal;
    _meterTop.position = ccp(_meterTop.position.x, (_meterMiddle.position.y + (_meterMiddle.contentSize.height * _meterMiddle.scaleY)));
    
    CCLOG(@"Rank: %i", [GameState sharedInstance].playerRank);
}

- (void)levelOver
{
    _isLevelOver = TRUE;
    
    // stopTimer
    [self stopTimer];
    
    // update Level Over Popup and display
    [self updateLevelOverPopup];
    [_levelOverPopup setVisible:TRUE];
    
    // set level number to next level
    [[GameState sharedInstance] setLevelNum:[GameState sharedInstance].levelNum + 1];
    
    // persist meter scale
    [[GameState sharedInstance] setMeterScale:_meterMiddle.scaleY];
}

# pragma mark - Helper Methods

- (void)updateLevelOverPopup
{
    [_levelOverPopup updateRecirculateLabel:numFavoritedCorrectly];
    [_levelOverPopup updateFavoriteLabel:numFavoritedCorrectly];
    [_levelOverPopup updateScoreLabel];
    
    // if Rank increased this level, update Rank label
    if(updateRankForLevel)
    {
        [_levelOverPopup updateRankLabel];
    }
    
    // reset Rank flag
    updateRankForLevel = FALSE;
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)pauseGame
{
    _timePaused = _timeSinceTimerBegan.timeIntervalSinceNow;
    _fireDatePaused= _timer.fireDate;
    
    [_timer invalidate];
}

- (void)resumeGame
{

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

// TODO: create timer

-(void) startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(timerInterval - timerElapsed) target:self selector:@selector(fired) userInfo:nil repeats:NO];
    timerStarted = [NSDate date];
}

-(void) fired
{
    [timer invalidate];
    timer = nil;
    timerElapsed = 0.0;
    [self startTimer];
    
    // react to timer event here
    int newTime =  _clock.timeLeft.string.intValue - TIMER_INTERVAL_IN_SECONDS;
    
    if(newTime == 15)
    {
        [_tutorialMeterPopup openPopup];
    }
    
    _clock.timeLeft.string = [NSString stringWithFormat:@"%d", newTime];
    
    // level over
    if(newTime == 0)
    {
        [self levelOver];
    }
}

-(void) pauseTimer {
    
    [timer invalidate];
    timer = nil;
    timerElapsed = [[NSDate date] timeIntervalSinceDate:timerStarted];
}

@end
