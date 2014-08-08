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
#import "TutorialMeterPopup.h"
#import "TutorialInboxPopup.h"
#import "Utilities.h"

// TODO: remove this - only here to compensate for slow simulator animation
static const int TESTING_SPEED_MULTIPLIER = 1;
static const BOOL TESTING_RUN_TUTORIAL = FALSE;

static NSString *ANIMATION_INCREASE_RANK = @"FlashingIconAnimation";
static NSString *ANIMATION_NEARING_GAME_OVER = @"FlashingMeterAnimation";

static const int NUM_STATUSES = 28; // num larger than the tallest device screen height
static const int STATUS_SPACING = 4;

//static const CGFloat MAX_NUM_LEVELS = 10;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;

static const int TIMER_INTERVAL_IN_SECONDS = 1;

// configuration when tutorial popups occur
static const int TUTORIAL_METER_POPUP_IN_LEVEL = 1;
static const int TUTORIAL_METER_POPUP_AT_TIME = 5;
static const int TUTORIAL_INBOX_POPUP_IN_LEVEL = 2;
static const int TUTORIAL_INBOX_POPUP_AT_TIME = 5;

@implementation Gameplay
{
    // declared in SpriteBuilder
    CCNode *_stream;
    Clock *_clock;
    CCSprite *_meterBottom;
    CCSprite *_meterIcon;
    CCNode *_messageNotification;
    CCLabelTTF *_numInboxNotifications;
    LevelOverPopup *_levelOverPopup;
    TutorialMeterPopup *_tutorialMeterPopup;
    TutorialInboxPopup *_tutorialInboxPopup;
    CCNodeColor *_blurBackgroundLayer;
    ///////////////////////////////////////
    
    // declared in class
    SocialMediaStatus *_statuses[NUM_STATUSES];
    NSMutableArray *_topicsToRecirculate;
    NSMutableArray *_topicsToFavorite;
    Level *_currentLevel;
    
    int _actionTypeRecirculate;
    int _actionTypeFavorite;
    int _numRecirculatedCorrectly;
    int _numFavoritedCorrectly;
    
    BOOL updateRankForLevel;
    
    NSTimer *_timer;
    int _timerInterval;
    double _timerElapsed;
    NSDate *_timerStarted;
    
    CCAnimationManager *_increaseRankAnimationManager;
    CCAnimationManager *_gameOverAnimationManager;
    
    CCAction *_easeInToCenter;
    
    BOOL _isScrolling;
}

- (void)didLoadFromCCB
{
    // always run Tutorial if in test
    if (TESTING_RUN_TUTORIAL) { [GameState sharedInstance].isTutorialComplete = FALSE; }
    
    // initialize variables
    _numStatuses = NUM_STATUSES;
    _statusSpacing = STATUS_SPACING;
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // animation
    _increaseRankAnimationManager = _meterIcon.animationManager;
    _gameOverAnimationManager = _meterBackground.animationManager;
    
    // actions
     _easeInToCenter = [CCActionMoveTo actionWithDuration:2.0 position:ccp(0.5,0.5)];
    
    // timer
    _timerInterval = TIMER_INTERVAL_IN_SECONDS;
    _timerElapsed = 0.0;
    
    // clock
    _clock.gameplay = self;
    
    // level
    _isLevelOver = FALSE;
    _currentLevel = [[Level alloc] initWithLevelNum:[GameState sharedInstance].levelNum];
    [[GameState sharedInstance] setStreamSpeed:_currentLevel.streamSpeed];
    _levelOverPopup.gameplay = self;
    
    // get order recirculate/favorite/avoid for this set of Statuses
    float percentToRecirculate = (!([[GameState sharedInstance].trendsToRecirculate count]) > 0) ? 0.0 : PERCENTAGE_STATUS_TO_RECIRCULATE;
    float percentToFavorite = (!([[GameState sharedInstance].trendsToFavorite count]) > 0) ? 0.0 : PERCENTAGE_STATUS_TO_FAVORITE;
    
    // statuses
    _actionTypeRecirculate = [GameState sharedInstance].actionTypeRecirculate;
    _actionTypeFavorite = [GameState sharedInstance].actionTypeFavorite;
    _numRecirculatedCorrectly = 0;
    _numFavoritedCorrectly = 0;
    
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:percentToRecirculate percentToFavorite:percentToFavorite];
    
    // rank
    updateRankForLevel = TRUE; // set so rank is updated first round
    
    // meter
    _meterMiddle.scaleY = [GameState sharedInstance].meterScale;
    //    _meterMiddle.positionInPoints = ccp(_meterMiddle.positionInPoints.x, _meterBottom.contentSize.height);
    //    _meterTop.position = ccp(_meterTop.position.x, (_meterMiddle.position.y + (_meterMiddle.contentSize.height * _meterMiddle.scaleY)));
    
    // popups
    _tutorialMeterPopup.gameplay = self;
    _tutorialInboxPopup.gameplay = self;
    
    // stream
    _isScrolling = TRUE;
    
    // SocialMediaStatus objects
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, (i*(height + _statusSpacing)) + height/2);
        
        if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", _actionTypeRecirculate]])
        {
            status.actionType = _actionTypeRecirculate;
            
            _topicsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
            
            status.statusText.string = _topicsToRecirculate[0 + arc4random() % ([_topicsToRecirculate count])];
        }
        else if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", _actionTypeFavorite]])
        {
            status.actionType = _actionTypeFavorite;
            
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
    
    // sttart timer
    [self resumeGame];
}

- (void)update:(CCTime)delta
{
    float meterMiddleStart = _meterMiddle.scaleY;
    
    if(_isScrolling)
    {
        // scrolling of SocialMediaStatues
        for(int i = 0; i < _numStatuses; i++)
        {
            SocialMediaStatus *status = _statuses[i];
            
            status.position = ccp(status.position.x, status.position.y - ([GameState sharedInstance].streamSpeed * TESTING_SPEED_MULTIPLIER));
            
            // if status about to exit screen and action not pressed, flash correct action
            if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2)))
            {
                if(status.recirculateButton.enabled && (status.actionType == _actionTypeRecirculate))
                {
                    if(!status.hasFlashedBeforeExitingScreen)
                    {
                        [status flashRecirculateButton];
                        status.hasFlashedBeforeExitingScreen = TRUE;
                    }
                }
                
                if(status.favoriteButton.enabled && (status.actionType == _actionTypeFavorite))
                {
                    if(!status.hasFlashedBeforeExitingScreen)
                    {
                        [status flashFavoriteButton];
                        status.hasFlashedBeforeExitingScreen = TRUE;
                    }
                }
            }
            
            // status is at bottom of screen
            if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) * -1))
            {
                status.isAtScreenBottom = TRUE;
                
                // if status is not disabled and should have been Recir/Faved, decrease Meter
                [status checkState];
                
                // change topic, move to top, etc.
                [status refresh];
            }
        }
        
        float meterMiddleScaled = _meterMiddle.scaleY;
//        
//                CCLOG(@"meterMiddleStart = %f; meterMiddleScaled = %f", meterMiddleStart, meterMiddleScaled);
//        
//        if(meterMiddleScaled <= 3.0 & meterMiddleScaled > 1.0)
//        {
//            [_gameOverAnimationManager runAnimationsForSequenceNamed:ANIMATION_NEARING_GAME_OVER];
//        }
//        
        // if meter scaling resulted in scale hitting 1.0, game is over
        if(meterMiddleStart < 1.0 || meterMiddleScaled < 1.0)
        {
            [self pauseGame];
            [self gameOver];
        }
    }
    
    float iconPosition = _meterIcon.positionInPoints.y;
    
    // meter middle in world space
    float meterMiddlePosition = [_meterBottom.parent convertToNodeSpace:[[_meterMiddle parent] convertToWorldSpace:_meterMiddle.positionInPoints]].y + ((_meterMiddle.contentSize.height * _meterMiddle.scaleY) * _meterBottom.scaleY);
    
    // if meter scaling resulted in scale hitting the top, increase player rank
    if(meterMiddlePosition >= (iconPosition - (_meterIcon.contentSize.height / 2)))
    {
        [self increaseRank];
    }
}

# pragma mark - Instance Methods

- (void)incrementStatusHandledCorrectlyOfActionType:(int)actionType
{
    if(actionType == _actionTypeRecirculate)
    {
        _numRecirculatedCorrectly++;
    }
    
    if(actionType == _actionTypeFavorite)
    {
        _numFavoritedCorrectly++;
    }
}

-(void) fired
{
    [_timer invalidate];
    _timer = nil;
    _timerElapsed = 0.0;
    [self resumeGame];
    
    int newTime =  _clock.timeLeft.string.intValue - TIMER_INTERVAL_IN_SECONDS;
    
    // if tutorial hasn't been completed
    if(!([GameState sharedInstance].isTutorialComplete))
    {
        // meter tutorial
        if(_currentLevel.levelNum == TUTORIAL_METER_POPUP_IN_LEVEL)
        {
            if(newTime == _clock.numSecondsPerLevel - TUTORIAL_METER_POPUP_AT_TIME)
            {
                [_tutorialMeterPopup openPopup];
            }
        }
        
        // inbox tutorial
        if(_currentLevel.levelNum == TUTORIAL_INBOX_POPUP_IN_LEVEL)
        {
            if(newTime == _clock.numSecondsPerLevel - TUTORIAL_INBOX_POPUP_AT_TIME)
            {
                [_tutorialInboxPopup openPopup];
            }
        }
    }
    
    _clock.timeLeft.string = [NSString stringWithFormat:@"%d", newTime];
    
    // level over
    if(newTime == 0)
    {
        [self levelOver];
    }
}

- (void)pauseTimer
{
    [_timer invalidate];
    _timer = nil;
    _timerElapsed = [[NSDate date] timeIntervalSinceDate:_timerStarted];
}

-(void) pauseGame
{
    [self pauseTimer];
    [self pauseScrolling];
}

-(void) resumeGame
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:(_timerInterval - _timerElapsed) target:self selector:@selector(fired) userInfo:nil repeats:NO];
    _timerStarted = [NSDate date];
    
    _isScrolling = TRUE;
}

- (void)gameOver
{
    // play sound
    [[Utilities sharedInstance] playSoundGameOver];
    
    [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + _numRecirculatedCorrectly + _numFavoritedCorrectly;
    
    // load GameOver scene
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    
    // reset current Level
    _currentLevel = nil;
    
    // lower background music
    [[Utilities sharedInstance] lowerVolume];
    
    // reset global values
    [[GameState sharedInstance] clearGameState];
}

- (void) toggleInbox
{
    [_inbox toggleVisibility];
}

# pragma mark - Custom Methods

- (void)increaseRank
{
    // play sound
    [[Utilities sharedInstance] playSoundRankIncrease];
    
    // play animation
    [_increaseRankAnimationManager runAnimationsForSequenceNamed:ANIMATION_INCREASE_RANK];
    
    // set flag
    updateRankForLevel = TRUE;
    
    // save increased rank to GameState
    [[GameState sharedInstance] setPlayerRank:([GameState sharedInstance].playerRank + 1)];
    
    // reset meter height
    _meterMiddle.scaleY = [GameState sharedInstance].meterScaleDefault;
}

- (void)levelOver
{
    _isLevelOver = TRUE;
    
    _levelOverPopup.userInteractionEnabled = FALSE;
    _levelOverPopup.visible = TRUE;
    
    // if this level is complete, tutorial has been completed
    if(_currentLevel.levelNum >= TUTORIAL_INBOX_POPUP_IN_LEVEL)
    {
        [GameState sharedInstance].isTutorialComplete = true;
    }
    
    // blur background
    _blurBackgroundLayer.visible = TRUE;
    
    // lower sound
    [[Utilities sharedInstance] lowerVolume];
    
    // pause timer
    [self pauseTimer];
    
    // update Level Over Popup
    [self updateLevelOverPopup];
    
    // display Level Over Popup
    [_levelOverPopup runAction:_easeInToCenter];
    
    _levelOverPopup.userInteractionEnabled = TRUE;
    
    // set level number to next level
    [[GameState sharedInstance] setLevelNum:[GameState sharedInstance].levelNum + 1];
    
    // persist meter scale
    [[GameState sharedInstance] setMeterScale:_meterMiddle.scaleY];
}

# pragma mark - Helper Methods

- (void)updateLevelOverPopup
{
    [_levelOverPopup updateRecirculateLabel:_numRecirculatedCorrectly];
    [_levelOverPopup updateFavoriteLabel:_numFavoritedCorrectly];
    [_levelOverPopup updateScoreLabel];
    
    // if Rank increased this level, update Rank label
    if(updateRankForLevel)
    {
        [_levelOverPopup updateRankLabel];
        
        // reset Rank flag
        updateRankForLevel = FALSE;
    }
}

- (NSMutableArray *)getRandomActionTypes:(int)numStatuses
                    percentToRecirculate:(CGFloat)percentToRecirculate
                       percentToFavorite:(CGFloat)percentToFavorite
{
    NSMutableArray *statuses = [[NSMutableArray alloc] initWithCapacity:numStatuses];
    double recirculatedCounter = floor(numStatuses * percentToRecirculate);
    double favoritedCounter = floor(numStatuses * percentToFavorite);
    
    // make sure first few are not playable
    statuses[0] = [NSString stringWithFormat:@"%d", 0];
    statuses[1] = [NSString stringWithFormat:@"%d", 0];
    
    // start i after first few
    for(int i = 2; i < numStatuses; i++)
    {
        if(recirculatedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"%d", _actionTypeRecirculate];
            recirculatedCounter--;
        }
        else if(favoritedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"%d", _actionTypeFavorite];
            favoritedCounter--;
        }
        else
        {
            statuses[i] = [NSString stringWithFormat:@"%d", 0];
        }
    }
    
    // shuffle order - start i after first few
    for(int i = 2; i < numStatuses; i++)
    {
        NSInteger remainingCount = numStatuses - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [statuses exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return statuses;
}

- (void)pauseScrolling
{
    _isScrolling = FALSE;
}

@end