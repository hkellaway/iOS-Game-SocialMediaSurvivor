//
//  GameState.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString *const GAME_STATE_LEVEL_NUM_KEY = @"GameStateLevelNumKey";
static NSString *const GAME_STATE_STREAM_SPEED_KEY = @"GameStateStreamSpeedKey";
static NSString *const GAME_STATE_LEVEL_ALL_TOPICS_KEY = @"GameStateAllTopicsKey";
static NSString *const GAME_STATE_TRENDS_TO_RECIRCULATE_KEY = @"GameStateTrendsToRecirculateKey";
static NSString *const GAME_STATE_TRENDS_TO_FAVORITE_KEY = @"GameStateTrendsToFavoriteKey";
static NSString *const GAME_STATE_PLAYER_RANK_KEY = @"GameStatePlayerRankKey";
static NSString *const GAME_STATE_PLAYER_SCORE_KEY = @"GameStatePlayerScoreKey";
static NSString *const GAME_STATE_METER_SCALE_KEY = @"GameStateMeterScaleKey";
static NSString *const GAME_STATE_FLAG_ISTUTORIALCOMPLETE = @"GameStateFlagIsTutorialComplete";

static int const DEFAULT_LEVEL_NUM = 1;
static double const DEFAULT_STREAM_SPEED = 0.5;
static int const DEFAULT_PLAYER_RANK = 0;
static int const DEFAULT_PLAYER_SCORE = 0;
static double const DEFAULT_METER_SCALE = 5.0;

@implementation GameState
{
    NSNumber *levelNumDefault;
    NSNumber *streamSpeedDefault;
    NSNumber *playerRankDefault;
    NSNumber *playerScoreDefault;
    NSNumber *meterScaleDefault;
    NSMutableArray *allTopicsDefault;
    NSMutableArray *trendsToRecirculateDefault;
    NSMutableArray *trendsToFavoriteDefault;
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
        _meterScaleOriginal = DEFAULT_METER_SCALE;
        
        // set defaults
        levelNumDefault = [NSNumber numberWithInt:DEFAULT_LEVEL_NUM];
        streamSpeedDefault = [NSNumber numberWithDouble: DEFAULT_STREAM_SPEED];
        playerRankDefault = [NSNumber numberWithInt: DEFAULT_PLAYER_RANK];
        playerScoreDefault = [NSNumber numberWithInt: DEFAULT_PLAYER_SCORE];
        meterScaleDefault = [NSNumber numberWithDouble:DEFAULT_METER_SCALE];
        allTopicsDefault = [NSMutableArray array];
        trendsToRecirculateDefault = [NSMutableArray array];
        trendsToFavoriteDefault = [NSMutableArray array];
        
        // clear GameState
        [self clearGameState];

        // if tutorial not already marked as complete ever, record
        NSString *currentTutorialState = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_FLAG_ISTUTORIALCOMPLETE];
        
        // if tutorial state not recorded, set to not complete
        if(currentTutorialState == nil || ([currentTutorialState isEqual: @"0"]))
        {
            [self setFlagIsTutorialComplete:FALSE];
        }
        
        // load in all Topics if none are available
        _allTopics = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_LEVEL_ALL_TOPICS_KEY];
        
        if(!_allTopics)
        {
            _allTopics = [NSMutableArray array];
            
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

- (void)setFlagIsTutorialComplete:(BOOL)isTutorialComplete
{
    _isTutorialComplete = isTutorialComplete;
    NSString *isTutorialCompleteString = [NSString stringWithFormat:@"%i", isTutorialComplete];
    
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:isTutorialCompleteString forKey:GAME_STATE_FLAG_ISTUTORIALCOMPLETE];
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
    [[NSUserDefaults standardUserDefaults]setObject:levelNumDefault forKey:GAME_STATE_LEVEL_NUM_KEY];
    _levelNum = [levelNumDefault integerValue];
    
    // stream speed
    [[NSUserDefaults standardUserDefaults]setObject:streamSpeedDefault forKey:GAME_STATE_STREAM_SPEED_KEY];
    _streamSpeed = [streamSpeedDefault doubleValue];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearGameState
{
    // NOTE: do not clear isTutorialComplete
    
    // level num
    [[NSUserDefaults standardUserDefaults]setObject:levelNumDefault forKey:GAME_STATE_LEVEL_NUM_KEY];
    [self setLevelNum:[levelNumDefault integerValue]];
    
    // stream speed
    [[NSUserDefaults standardUserDefaults]setObject:streamSpeedDefault forKey:GAME_STATE_STREAM_SPEED_KEY];
    [self setStreamSpeed:[streamSpeedDefault doubleValue]];
    
    // meter scale
    [[NSUserDefaults standardUserDefaults]setObject:meterScaleDefault forKey:GAME_STATE_METER_SCALE_KEY];
    [self setMeterScale:[meterScaleDefault doubleValue]];
    
    // player rank
    [[NSUserDefaults standardUserDefaults]setObject:playerRankDefault forKey:GAME_STATE_PLAYER_RANK_KEY];
    _playerRank = [playerRankDefault integerValue];
    [self setPlayerRank:[playerRankDefault integerValue]];
    
    // player score
    [[NSUserDefaults standardUserDefaults]setObject:playerScoreDefault forKey:GAME_STATE_PLAYER_SCORE_KEY];
    [self setPlayerScore:[playerScoreDefault integerValue]];
    
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
