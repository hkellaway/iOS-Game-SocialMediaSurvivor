//
//  GameState.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"
#import "Utilities.h"

// shared resource names
static NSString *const GAME_STATE_IMAGE_NAME_RECIRCULATE_KEY = @"GameStateImageNameRecirculateKey";
static NSString *const GAME_STATE_IMAGE_NAME_FAVORITE_KEY = @"GameStateImageNameFavoriteKey";

// game mechanics
static NSString *const GAME_STATE_LEVEL_NUM_KEY = @"GameStateLevelNumKey";
static NSString *const GAME_STATE_STREAM_SPEED_KEY = @"GameStateStreamSpeedKey";
static NSString *const GAME_STATE_METER_SCALE_KEY = @"GameStateMeterScaleKey";
static NSString *const GAME_STATE_ACTION_TYPE_RECIRCULATE_KEY = @"GameStateActionTypeRecirculateKey";
static NSString *const GAME_STATE_ACTION_TYPE_FAVORITE_KEY = @"GameStateActionTypeFavoriteKey";

// player values
static NSString *const GAME_STATE_PLAYER_RANK_KEY = @"GameStatePlayerRankKey";
static NSString *const GAME_STATE_PLAYER_SCORE_KEY = @"GameStatePlayerScoreKey";
static NSString *const GAME_STATE_HIGH_SCORE_KEY = @"GameStateHighScoreKey";
static NSString *const GAME_STATE_FLAG_HASACHIEVEDHIGHSCORE_KEY = @"GameStateFlagHasAchievedHighScoreKey";

// topics
static NSString *const GAME_STATE_LEVEL_ALL_TOPICS_KEY = @"GameStateAllTopicsKey";
static NSString *const GAME_STATE_TRENDS_TO_RECIRCULATE_KEY = @"GameStateTrendsToRecirculateKey";
static NSString *const GAME_STATE_TRENDS_TO_FAVORITE_KEY = @"GameStateTrendsToFavoriteKey";

// tutorial
static NSString *const GAME_STATE_FLAG_ISTUTORIALCOMPLETE_KEY = @"GameStateFlagIsTutorialCompleteKey";


// set defaults
static NSString *IMAGE_NAME_RECIRCULATE = @"SocialMediaGameAssets/button_recirculate_noshadow.png";
static NSString *IMAGE_NAME_FAVORITE = @"SocialMediaGameAssets/button_favorite_noshadow.png";

static int const DEFAULT_LEVEL_NUM = 1;
static double const DEFAULT_STREAM_SPEED = 0.5;
static double const DEFAULT_METER_SCALE = 5.0;
static int const ACTION_TYPE_RECIRCULATE = 1;
static int const ACTION_TYPE_FAVORITE = 2;

static int const DEFAULT_PLAYER_RANK = 0;
static int const DEFAULT_PLAYER_SCORE = 0;

@implementation GameState
{    
    NSNumber *_levelNumDefault;
    NSNumber *_streamSpeedDefault;
    
    NSNumber *_playerRankDefault;
    NSNumber *_playerScoreDefault;

    NSMutableArray *_allTopicsDefault;
    NSMutableArray *_trendsToRecirculateDefault;
    NSMutableArray *_trendsToFavoriteDefault;
}

+(instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        // set instance variables
        _meterScaleDefault = DEFAULT_METER_SCALE;
        
        _imageNameRecirculate = IMAGE_NAME_RECIRCULATE;
        _imageNameFavorite = IMAGE_NAME_FAVORITE;
        
        _actionTypeRecirculate = ACTION_TYPE_RECIRCULATE;
        _actionTypeFavorite = ACTION_TYPE_FAVORITE;
        
        // set defaults
        _levelNumDefault = [NSNumber numberWithInt:DEFAULT_LEVEL_NUM];
        _streamSpeedDefault = [NSNumber numberWithDouble: DEFAULT_STREAM_SPEED];
        _playerRankDefault = [NSNumber numberWithInt: DEFAULT_PLAYER_RANK];
        _playerScoreDefault = [NSNumber numberWithInt: DEFAULT_PLAYER_SCORE];
        _allTopicsDefault = [NSMutableArray array];
        _trendsToRecirculateDefault = [NSMutableArray array];
        _trendsToFavoriteDefault = [NSMutableArray array];
        
        // clear GameState
        [self clearGameState];

        // high score
        NSString *currentHighScore = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_HIGH_SCORE_KEY];
        
        if(currentHighScore == nil)
        {
            [self setHighScore:0];
        }

        // high score flag
        NSString *currentHighScoreFlagState = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_FLAG_HASACHIEVEDHIGHSCORE_KEY];
        
        // if state not recorded, set to false
        if(currentHighScoreFlagState == nil || ([currentHighScoreFlagState isEqual: @"0"]))
        {
            [self setHasAchievedHighScore:FALSE];
        }
        
        
        // if tutorial not already marked as complete ever, record
        NSString *currentTutorialState = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_FLAG_ISTUTORIALCOMPLETE_KEY];
        
        // if tutorial state not recorded, set to not complete
        if(currentTutorialState == nil || ([currentTutorialState isEqual: @"0"]))
        {
            [self setIsTutorialComplete:FALSE];
        }
        
        // load in all Topics if none are available
        _allTopics = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_LEVEL_ALL_TOPICS_KEY];
        
        if(!_allTopics)
        {
            _allTopics = [NSMutableArray array];
            
            // convert static property list into corresponding property-list objects
            // Topics p-list contains array of dictionarys
            NSArray *topicsArray = [Utilities sharedInstance].allTopicsArray;
            
            for(int i = 0; i < [topicsArray count]; i++)
            {
                [_allTopics addObject:[(NSDictionary *)topicsArray[i] objectForKey:@"Noun"]];
            }
            
        }
        
        // save defaults
        [[NSUserDefaults standardUserDefaults]synchronize];
    
    }
    
    return self;
}

# pragma mark - setter overides

- (void)setIsTutorialComplete:(BOOL)isTutorialComplete
{
    _isTutorialComplete = isTutorialComplete;
    NSString *isTutorialCompleteString = [NSString stringWithFormat:@"%i", isTutorialComplete];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:isTutorialCompleteString forKey:GAME_STATE_FLAG_ISTUTORIALCOMPLETE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setStreamSpeed:(double)streamSpeed
{
    _streamSpeed = streamSpeed;
    
    NSNumber *streamSpeedNSNumber = [NSNumber numberWithInt:streamSpeed];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:streamSpeedNSNumber forKey:GAME_STATE_STREAM_SPEED_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setLevelNum:(NSInteger)levelNum
{
    _levelNum = levelNum;
    
    NSNumber *levelNSNumber = [NSNumber numberWithInt:levelNum];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:levelNSNumber forKey:GAME_STATE_LEVEL_NUM_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setMeterScale:(double)meterScale
{
    _meterScale = meterScale;
    
    NSNumber *meterScaleNSNumber = [NSNumber numberWithInt:meterScale];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:meterScaleNSNumber forKey:GAME_STATE_METER_SCALE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setPlayerRank:(NSInteger)playerRank
{
    _playerRank = playerRank;
    
    NSNumber *rankNSNumber = [NSNumber numberWithInt:playerRank];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:rankNSNumber forKey:GAME_STATE_PLAYER_RANK_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setPlayerScore:(NSInteger)playerScore
{
    _playerScore = playerScore;
    
    NSNumber *scoreNSNumber = [NSNumber numberWithInt:playerScore];
    
    // store chance
    [[NSUserDefaults standardUserDefaults]setObject:scoreNSNumber forKey:GAME_STATE_PLAYER_SCORE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setHighScore:(NSInteger)highScore
{
    _highScore = highScore;
    
    NSNumber *scoreNSNumber = [NSNumber numberWithInt:highScore];
    
    // store chance
    [[NSUserDefaults standardUserDefaults]setObject:scoreNSNumber forKey:GAME_STATE_HIGH_SCORE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setHasAchievedHighScore:(BOOL)hasAchievedHighScore
{
    _hasAchievedHighScore = hasAchievedHighScore;
    NSString *hasAchievedHighScoreString = [NSString stringWithFormat:@"%i", hasAchievedHighScore];
    
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:hasAchievedHighScoreString forKey:GAME_STATE_FLAG_HASACHIEVEDHIGHSCORE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setTrendsToRecirculate:(NSMutableArray *)trendsToRecirculate
{
    _trendsToRecirculate = trendsToRecirculate;
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:trendsToRecirculate forKey:GAME_STATE_TRENDS_TO_RECIRCULATE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setTrendsToFavorite:(NSMutableArray *)trendsToFavorite
{
    _trendsToFavorite = trendsToFavorite;
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:trendsToFavorite forKey:GAME_STATE_TRENDS_TO_FAVORITE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

# pragma mark - Instance Methods

// clear settings related to Level just played
- (void)clearLevelSettings
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateLevelNumKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateStreamSpeedKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateTrendsToRecirculateKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateTrendsToFavoriteKey"];
    
    // level num
    [[NSUserDefaults standardUserDefaults]setObject:_levelNumDefault forKey:GAME_STATE_LEVEL_NUM_KEY];
    _levelNum = [_levelNumDefault integerValue];
    
    // stream speed
    [[NSUserDefaults standardUserDefaults]setObject:_streamSpeedDefault forKey:GAME_STATE_STREAM_SPEED_KEY];
    _streamSpeed = [_streamSpeedDefault doubleValue];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearGameState
{
    // NOTE: do not clear isTutorialComplete
    
    [self clearLevelSettings]; // level num, stream speed, trends
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateMeterScaleKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStatePlayerRankKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStatePlayerScoreKey"];
    
    // meter scale
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithDouble:DEFAULT_METER_SCALE] forKey:GAME_STATE_METER_SCALE_KEY];
    _meterScale = _meterScaleDefault;
    
    // player rank
    [[NSUserDefaults standardUserDefaults]setObject:_playerRankDefault forKey:GAME_STATE_PLAYER_RANK_KEY];
    _playerRank = [_playerRankDefault integerValue];
    
    // player score
    [[NSUserDefaults standardUserDefaults]setObject:_playerScoreDefault forKey:GAME_STATE_PLAYER_SCORE_KEY];
    _playerScore = [_playerScoreDefault integerValue];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

# pragma mark - Helper Methods

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

@end
