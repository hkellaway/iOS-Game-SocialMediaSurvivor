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

// TODO: remove this - only here to compensate for slow simulator animation
static const int TESTING_SPEED_MULTIPLIER = 1;
static const BOOL TESTING_RUN_TUTORIAL = FALSE;

static NSString *ANIMATION_INCREASE_RANK = @"FlashingIconAnimation";
static NSString *ANIMATION_NEARING_GAME_OVER = @"FlashingMeterAnimation";

// TODO: make this number larger than the largest amount that will fit on the tallest device
static const int NUM_STATUSES = 28;
static const int STATUS_SPACING = 4;

//static const CGFloat MAX_NUM_LEVELS = 10;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;

static const int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;

static const int TIMER_INTERVAL_IN_SECONDS = 1;

// configuration when tutorial popups occur
static const int TUTORIAL_METER_POPUP_IN_LEVEL = 1;
static const int TUTORIAL_METER_POPUP_AT_TIME = 5;
static const int TUTORIAL_INBOX_POPUP_IN_LEVEL = 2;
static const int TUTORIAL_INBOX_POPUP_AT_TIME = 5;

@implementation Gameplay
{
    // TODO: remove this
    CCSprite *_meterTop;
    
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
    
    int numRecirculatedCorrectly;
    int numFavoritedCorrectly;
    
    BOOL updateRankForLevel;
    
    NSTimer *timer;
    int timerInterval;
    double timerElapsed;
    NSDate *timerStarted;
    
    CCAnimationManager *_increaseRankAnimationManager;
    CCAnimationManager *_gameOverAnimationManager;
    
    CCAction *_easeInToCenter;
    
    OALSimpleAudio *_audio;
    
    BOOL _isScrolling;
}

- (void)didLoadFromCCB
{
    //    if([GameState sharedInstance].levelNum > MAX_NUM_LEVELS)
    //    {
    //        [self gameOver];
    //    }
    
    // TODO: remove this
    _meterTop.visible = FALSE;
    if (TESTING_RUN_TUTORIAL) { [GameState sharedInstance].isTutorialComplete = FALSE; }
    // ****************//
    
    
    
    // initialize variables
    _numStatuses = NUM_STATUSES;
    _statusSpacing = STATUS_SPACING;
    
    // set visibility of elements
    _messageNotification.visible = FALSE;
    
    // audio
    _audio = [OALSimpleAudio sharedInstance];
    
    // animation
    _increaseRankAnimationManager = _meterIcon.animationManager;
    _gameOverAnimationManager = _meterBackground.animationManager;
    
    // actions
     _easeInToCenter = [CCActionMoveTo actionWithDuration:2.0 position:ccp(0.5,0.5)];
    
    // timer
    timerInterval = TIMER_INTERVAL_IN_SECONDS;
    timerElapsed = 0.0;
    
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
    
    
    NSMutableArray *randomActions = [self getRandomActionTypes:_numStatuses percentToRecirculate:percentToRecirculate percentToFavorite:percentToFavorite];
    
    // statuses
    numRecirculatedCorrectly = 0;
    numFavoritedCorrectly = 0;
    
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
                if(status.recirculateButton.enabled && (status.actionType == ACTION_TYPE_RECIRCULATE))
                {
                    if(!status.hasFlashedBeforeExitingScreen)
                    {
                        [status flashRecirculateButton];
                        status.hasFlashedBeforeExitingScreen = TRUE;
                    }
                }
                
                if(status.favoriteButton.enabled && (status.actionType == ACTION_TYPE_FAVORITE))
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

-(void) fired
{
    [timer invalidate];
    timer = nil;
    timerElapsed = 0.0;
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
    [timer invalidate];
    timer = nil;
    timerElapsed = [[NSDate date] timeIntervalSinceDate:timerStarted];
}

-(void) pauseGame
{
    [self pauseTimer];
    [self pauseScrolling];
}

-(void) resumeGame
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(timerInterval - timerElapsed) target:self selector:@selector(fired) userInfo:nil repeats:NO];
    timerStarted = [NSDate date];
    
    _isScrolling = TRUE;
}

- (void)gameOver
{
    // play sound
    [_audio playEffect:@"Audio/gameover.wav" volume:0.5f pitch:1.0f pan:1.0f loop:FALSE];
    
    [GameState sharedInstance].playerScore = [GameState sharedInstance].playerScore + numRecirculatedCorrectly + numFavoritedCorrectly;
    
    // load GameOver scene
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
    
    // reset current Level
    _currentLevel = nil;
    
    // lower background music
    [_audio setBgVolume:([_audio bgVolume]/2)];
    
    // reset global values
    [[GameState sharedInstance] clearGameState];
}

# pragma mark - Custom Methods


- (void)toggleInbox
{
    [_inbox toggleVisibility];
}

- (void)increaseRank
{
    // play sound
    [_audio playEffect:@"Audio/highlow.wav" volume:50.0f pitch:1.0f pan:1.0f loop:FALSE];
    
    // play animation
    [_increaseRankAnimationManager runAnimationsForSequenceNamed:ANIMATION_INCREASE_RANK];
    
    // set flag
    updateRankForLevel = TRUE;
    
    // save increased rank to GameState
    [[GameState sharedInstance] setPlayerRank:([GameState sharedInstance].playerRank + 1)];
    
    // reset meter height
    _meterMiddle.scaleY = [GameState sharedInstance].meterScaleOriginal;
}

- (void)levelOver
{
    _isLevelOver = TRUE;
    _levelOverPopup.visible = TRUE;
    
    // if this level is complete, tutorial has been completed
    if(_currentLevel.levelNum >= TUTORIAL_INBOX_POPUP_IN_LEVEL)
    {
        [GameState sharedInstance].isTutorialComplete = true;
    }
    
    // blur background
    _blurBackgroundLayer.visible = TRUE;
    
    // pause timer
    [self pauseTimer];
    
    // update Level Over Popup
    [self updateLevelOverPopup];
    
    // display Level Over Popup
    [_levelOverPopup runAction:_easeInToCenter];
    
    // set level number to next level
    [[GameState sharedInstance] setLevelNum:[GameState sharedInstance].levelNum + 1];
    
    // persist meter scale
    [[GameState sharedInstance] setMeterScale:_meterMiddle.scaleY];
}

# pragma mark - Helper Methods

- (void)updateLevelOverPopup
{
    [_levelOverPopup updateRecirculateLabel:numRecirculatedCorrectly];
    [_levelOverPopup updateFavoriteLabel:numFavoritedCorrectly];
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