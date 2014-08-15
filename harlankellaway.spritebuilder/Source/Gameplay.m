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
#import "PausePopup.h"
#import "SentenceGenerator.h"
#import "Utilities.h"

// TODO: remove this - only here to compensate for slow simulator animation
static const BOOL TESTING_RUN_TUTORIAL = FALSE;

static NSString *ANIMATION_INCREASE_RANK = @"FlashingIconAnimation";
static NSString *ANIMATION_STREAK_ACHEIVED = @"StreakAnimation";

static const int NUM_STATUSES = 19; // num larger than the tallest device screen height (1024)
static const int STATUS_SPACING = 4;

static const int NUM_STATUSES_HANDLED_FOR_STREAK = 3;
static const float STREAM_SPEED_INCREASE = 0.2;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.4;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.4;

static const int NUM_SECONDS_PER_LEVEL = 36;
static const int TIMER_INTERVAL_IN_SECONDS = 1;

// configuration when tutorial popups occur
static const int TUTORIAL_METER_POPUP_IN_LEVEL = 1;
static const int TUTORIAL_METER_POPUP_AT_TIME = 3;
static const int TUTORIAL_INBOX_POPUP_IN_LEVEL = 1;
static const int TUTORIAL_INBOX_POPUP_AT_TIME = 8;

@implementation Gameplay
{
    // declared in SpriteBuilder
    CCNode *_stream;
    CCSprite *_meterBottom;
    CCSprite *_meterIcon;
    CCNode *_messageNotification;
    CCLabelTTF *_numInboxNotifications;
    CCLabelTTF *_streakLabel;
    Clock *_clock;
    LevelOverPopup *_levelOverPopup;
    TutorialMeterPopup *_tutorialMeterPopup;
    TutorialInboxPopup *_tutorialInboxPopup;
    CCNodeColor *_blurBackgroundLayer;
    PausePopup *_pausePopup;
    ///////////////////////////////////////
    
    // declared in class
    BOOL _isScrolling;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    NSMutableArray *_topicsToRecirculate;
    NSMutableArray *_topicsToFavorite;
    Level *_currentLevel;
    
    int _actionTypeRecirculate;
    int _actionTypeFavorite;
    int _numRecirculatedCorrectly;
    int _numFavoritedCorrectly;
    int _numRecirculatedIncorrectly;
    int _numFavoritedIncorrectly;
    int _streakCounter;
    
    BOOL updateRankForLevel;
    
    NSTimer *_timer;
    int _timerInterval;
    double _timerElapsed;
    NSDate *_timerStarted;
    
    CCAnimationManager *_increaseRankAnimationManager;
    
    CCAction *_easeInToCenter;
    CCAction *_fadeIn;
    CCAction *_fadeOut;
    
    SentenceGenerator *_sentenceGenerator;
}

- (void)didLoadFromCCB
{
    // always run Tutorial if in test
    if (TESTING_RUN_TUTORIAL) { [GameState sharedInstance].isTutorialComplete = FALSE; }
    
    // initialize variables
    _isScrolling = TRUE;
    
    _numStatuses = NUM_STATUSES;
    _statusSpacing = STATUS_SPACING;
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // animation
    _increaseRankAnimationManager = _meterIcon.animationManager;
    
    // actions
     _easeInToCenter = [CCActionMoveTo actionWithDuration:2.0 position:ccp(0.5,0.5)];
    _fadeIn = [CCActionFadeIn actionWithDuration:1.0];
    _fadeOut = [CCActionFadeOut actionWithDuration:1.0];
    
    // timer
    _timerInterval = TIMER_INTERVAL_IN_SECONDS;
    _timerElapsed = 0.0;
    
    // clock
    _clock.timeLeft = NUM_SECONDS_PER_LEVEL;
    
    // level
    _isLevelOver = FALSE;
    _currentLevel = [[Level alloc] initWithLevelNum:[GameState sharedInstance].levelNum];
    [[GameState sharedInstance] setStreamSpeed:_currentLevel.streamSpeed];
    _levelOverPopup.gameplay = self;
    
    // topics/actions
    _topicsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
    _topicsToFavorite = [GameState sharedInstance].trendsToFavorite;
    _actionTypeRecirculate = [GameState sharedInstance].actionTypeRecirculate;
    _actionTypeFavorite = [GameState sharedInstance].actionTypeFavorite;
    _numRecirculatedCorrectly = 0;
    _numFavoritedCorrectly = 0;
    _numRecirculatedIncorrectly = 0;
    _numFavoritedIncorrectly = 0;
    
    // get order recirculate/favorite/avoid for this set of Statuses
    float percentToRecirculate = (!([[GameState sharedInstance].trendsToRecirculate count]) > 0) ? 0.0 : PERCENTAGE_STATUS_TO_RECIRCULATE;
    float percentToFavorite = (!([[GameState sharedInstance].trendsToFavorite count]) > 0) ? 0.0 : PERCENTAGE_STATUS_TO_FAVORITE;
    
    // streak
    _streakCounter = 0;
    
    // rank
    updateRankForLevel = FALSE;
    
    // meter
    _meterMiddle.scaleY = [GameState sharedInstance].meterScale;
    
    // pause
    _isPaused = FALSE;
    _pausePopup.visible = FALSE;
    
    // popups
    _pausePopup.gameplay = self;
    _tutorialMeterPopup.gameplay = self;
    _tutorialInboxPopup.gameplay = self;
    
    // Sentence generator
    _sentenceGenerator = [[SentenceGenerator alloc] init];
    
    // SocialMediaStatus objects
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:percentToRecirculate percentToFavorite:percentToFavorite];
    NSMutableArray *usedTopics = [NSMutableArray arrayWithArray:_topicsToRecirculate];
    [usedTopics addObjectsFromArray:_topicsToFavorite];
    
    for(int i = 0; i < _numStatuses; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, (i*(height + _statusSpacing)) + height/2);
        
        if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", _actionTypeRecirculate]])
        {
            NSString *randomTopic = _topicsToRecirculate[0 + arc4random() % ([_topicsToRecirculate count])];
                                     
            status.actionType = _actionTypeRecirculate;
            
            NSString *statusText = [_sentenceGenerator getSentencWithTopic:randomTopic];
            status.statusText.string = statusText;
            
            CCLOG(@"Status: %@", statusText);
        }
        else if([randomActions[i] isEqualToString:[NSString stringWithFormat:@"%d", _actionTypeFavorite]])
        {
            NSString *randomTopic = _topicsToFavorite[0 + arc4random() % ([_topicsToFavorite count])];
            
            status.actionType = _actionTypeFavorite;
            
            NSString *statusText = [_sentenceGenerator getSentencWithTopic:randomTopic];
            status.statusText.string = statusText;
            
            CCLOG(@"Status: %@", statusText);
        }
        else
        {
            status.actionType = 0;
            
            NSMutableArray *allTopics = [GameState sharedInstance].allTopics;
            
            // don't use a topic thats to be recirculated/favorited as a random topic
            NSString *randomTopic = allTopics[0 + arc4random() % ([allTopics count])];
            
            // TODO: still possible to use incorrect topic
            for (NSString *topic in usedTopics)
            {
                if([randomTopic isEqualToString:topic])
                {
                    randomTopic = allTopics[0 + arc4random() % ([allTopics count])];
                }
            }
            
            NSString *statusText = [_sentenceGenerator getSentencWithTopic:randomTopic];
            status.statusText.string = statusText;
            
            CCLOG(@"Status: %@", statusText);
        }
        
        status.isAtScreenBottom = FALSE;
        
        // set weak property(s)
        status.gameplay = self;
        
        _statuses[i] = status;
        
//        status.position = ccp(0.5, 0.0);
        
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
    
    if((_streakCounter > 0) && ((_streakCounter % NUM_STATUSES_HANDLED_FOR_STREAK) == 0))
    {
        // increase stream speed
        [self increaseStreamSpeed];
        
        // reset counter
        _streakCounter = 0;
    }
    
    if(_isScrolling)
    {
        // scrolling of SocialMediaStatues
        for(int i = 0; i < _numStatuses; i++)
        {
            SocialMediaStatus *status = _statuses[i];
            
            status.position = ccp(status.position.x, status.position.y - (_currentLevel.streamSpeed));
            
            // if status about to exit screen and action not pressed, flash correct action
            if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) + 50))
            {
                if(status.recirculateButton.enabled && (status.actionType == _actionTypeRecirculate))
                {
                    // flash
                    if(!status.hasFlashedBeforeExitingScreen)
                    {
                        [status flashRecirculateButton];
                        status.hasFlashedBeforeExitingScreen = TRUE;
                    }
                    
                    // reset speed
                    [self resetStreamSpeed];
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
    if(meterMiddlePosition >= (iconPosition - ((_meterIcon.contentSize.height * _meterIcon.scaleY) / 2)))
    {
        [self increaseRank];
    }
}

# pragma mark - Instance Methods

- (void)incrementStatusHandledCorrectlyOfActionType:(int)actionType
{
    _streakCounter++;
    
    if(actionType == _actionTypeRecirculate)
    {
        _numRecirculatedCorrectly++;
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
    
    if(actionType == _actionTypeFavorite)
    {
        _numFavoritedCorrectly++;
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + 1;
    }
}

- (void)decrementStatusHandledCorrectlyOfActionType:(int)actionType
{
    // reset streak
    _streakCounter = 0;
    
    // reset speed
    [self resetStreamSpeed];
    
    if(actionType == _actionTypeRecirculate)
    {
        _numRecirculatedIncorrectly++;
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore - 1;
    }
    
    if(actionType == _actionTypeFavorite)
    {
        _numFavoritedIncorrectly++;
        [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore - 1;
    }
}

-(void) fired
{
    [_timer invalidate];
    _timer = nil;
    _timerElapsed = 0.0;
    [self resumeGame];
    
    int newTime =  _clock.timeLeft - TIMER_INTERVAL_IN_SECONDS;
    
    // if tutorial hasn't been completed
    if(!([GameState sharedInstance].isTutorialComplete))
    {
        // meter tutorial
        if(_currentLevel.levelNum == TUTORIAL_METER_POPUP_IN_LEVEL)
        {
            if(newTime == NUM_SECONDS_PER_LEVEL - TUTORIAL_METER_POPUP_AT_TIME)
            {
                [self pauseGame];
                [_tutorialMeterPopup openPopup];
            }
        }
        
        // inbox tutorial
        if(_currentLevel.levelNum == TUTORIAL_INBOX_POPUP_IN_LEVEL)
        {
            if(newTime == NUM_SECONDS_PER_LEVEL - TUTORIAL_INBOX_POPUP_AT_TIME)
            {
                [self pauseGame];
                [_tutorialInboxPopup openPopup];
            }
        }
    }
    
    _clock.timeLeft = newTime;
    
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

- (void)popupPauseScreen
{
    [self pauseGame];
 
    _isPaused = TRUE;
    
    // blur background
    _blurBackgroundLayer.visible = TRUE;
    
    [_pausePopup openPopup];
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
    
    if(_blurBackgroundLayer.visible)
    {
        _blurBackgroundLayer.visible = FALSE;
    }
    
    _isScrolling = TRUE;
    _isPaused = FALSE;
}

- (void)gameOver
{
    // play sound
    [[Utilities sharedInstance] playSoundGameOver];
    
    // set score
    int score = [GameState sharedInstance].playerScore + _numRecirculatedCorrectly + _numFavoritedCorrectly;
    if(score < 0) { score = 0; }
    [GameState sharedInstance].playerScore = score;
    
    // check if high score
    if(score > [GameState sharedInstance].highScore)
    {
        [GameState sharedInstance].highScore = score;
        [GameState sharedInstance].hasAchievedHighScore = TRUE;
    }
    
    // reset current Level
    _currentLevel = nil;
    
    // lower background music
    [[Utilities sharedInstance] lowerVolume];
    
    // MGWU SDK - Analytics
    NSNumber *playerScore = [NSNumber numberWithInt:[GameState sharedInstance].playerScore];
    NSNumber *level = [NSNumber numberWithInt:_currentLevel.levelNum];
    NSNumber *rank = [NSNumber numberWithInt:[GameState sharedInstance].playerRank];
    NSNumber *recirculatedCorrectly = [NSNumber numberWithInt:_numRecirculatedCorrectly];
    NSNumber *favoritedCorrectly = [NSNumber numberWithInt:_numRecirculatedIncorrectly];
    NSNumber *recirculatedIncorrectly = [NSNumber numberWithInt:_numFavoritedCorrectly];
    NSNumber *favoritedIncorrectly = [NSNumber numberWithInt:_numFavoritedIncorrectly];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: playerScore, @"score", level, @"level", rank, @"rank", recirculatedCorrectly, @"recirculatedCorrectly", favoritedCorrectly, @"favoritedCorrectly", recirculatedIncorrectly, @"recirculatedIncorrectly", favoritedIncorrectly, @"favoritedIncorrectly", nil];
    [MGWU logEvent:@"game_over" withParams:params];
    
    // load GameOver scene
    CCTransition *gameOverTransition = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0];
    
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:gameOverTransition];
    
    // reset global values
    [[GameState sharedInstance] clearGameState];
}

- (void)toggleInbox
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
    
    // MGWU SDK - Analytics
    NSNumber *score = [NSNumber numberWithInt:[GameState sharedInstance].playerScore];
    NSNumber *level = [NSNumber numberWithInt:_currentLevel.levelNum];
    NSNumber *rank = [NSNumber numberWithInt:[GameState sharedInstance].playerRank];
    NSNumber *recirculatedCorrectly = [NSNumber numberWithInt:_numRecirculatedCorrectly];
    NSNumber *favoritedCorrectly = [NSNumber numberWithInt:_numRecirculatedIncorrectly];
    NSNumber *recirculatedIncorrectly = [NSNumber numberWithInt:_numFavoritedCorrectly];
    NSNumber *favoritedIncorrectly = [NSNumber numberWithInt:_numFavoritedIncorrectly];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: score, @"score", level, @"level", rank, @"rank", recirculatedCorrectly, @"recirculatedCorrectly", favoritedCorrectly, @"favoritedCorrectly", recirculatedIncorrectly, @"recirculatedIncorrectly", favoritedIncorrectly, @"favoritedIncorrectly", nil];
    [MGWU logEvent:@"level_complete" withParams:params];
}

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

- (void)increaseStreamSpeed
{
    // play animation
    [_streakLabel runAction:_fadeIn];
    [_streakLabel runAction:_fadeOut];
    
    // increase speed
    _currentLevel.streamSpeed = _currentLevel.streamSpeed + STREAM_SPEED_INCREASE;
}

- (void)resetStreamSpeed
{
    _currentLevel.streamSpeed = [GameState sharedInstance].streamSpeed;
}

- (void)pauseScrolling
{
    _isScrolling = FALSE;
}

@end