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
        // set defaults
        levelNumDefault = @1;
        streamSpeedDefault = @0.5;
        playerRankDefault = @1;
        playerScoreDefault = @0;
        meterScaleDefault = @20.0;
        allTopicsDefault = [NSMutableArray array];
        trendsToRecirculateDefault = [NSMutableArray array];
        trendsToFavoriteDefault = [NSMutableArray array];
        
        [self clearGameState];
//        
//        // try to read in defaults - if nil, initialize
////        NSNumber *levelNum = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_LEVEL_NUM_KEY];
////
////        if(levelNum == nil)
////        {
////            levelNum = @1;
////        }
//        
//        self.levelNum = [levelNumDefault integerValue];
//        
////        NSNumber *streamSpeed = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_STREAM_SPEED_KEY];
////
////        if(streamSpeed == 0 || streamSpeed == nil)
////        {
////            streamSpeed = @0.5;
////            
////            [[NSUserDefaults standardUserDefaults]setObject:streamSpeed forKey:GAME_STATE_STREAM_SPEED_KEY];
////        }
//        
//        self.streamSpeed = [streamSpeedDefault doubleValue];
//        
////        NSNumber *meterScale = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_METER_SCALE_KEY];
////        
////        if(meterScale == nil)
////        {
////            meterScale = @20.0;
////            
////            [[NSUserDefaults standardUserDefaults]setObject:meterScale forKey:GAME_STATE_METER_SCALE_KEY];
////        }
//        
//        self.meterScale = [meterScaleDefault doubleValue];
//        
////        // load player's current Rank
////        NSNumber *playerRank = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_PLAYER_RANK_KEY];
////        
////        if(playerRank == nil)
////        {
////            playerRank = @1;
////        }
//        
//        self.playerRank = [playerRankDefault integerValue];
//        
////        // load player's current Score
////        NSNumber *playerScore = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_PLAYER_SCORE_KEY];
////        
////        if(playerScore == nil)
////        {
////            playerScore = @0;
////        }
//        
//        self.playerScore = [playerScoreDefault integerValue];
        
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
        
        // trends currently being recirculated
        NSMutableArray *trendsToRecirculate = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_TRENDS_TO_RECIRCULATE_KEY];
        
        if(!trendsToRecirculate)
        {
            trendsToRecirculate = [NSMutableArray array];
        }
        
        // trends currently being favorited
        NSMutableArray *trendsToFavorite = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_TRENDS_TO_FAVORITE_KEY];
        
        if(!trendsToFavorite)
        {
            trendsToFavorite = [NSMutableArray array];
        }
        
        // save defaults
        [[NSUserDefaults standardUserDefaults]synchronize];
    
    }
    
    return self;
}

# pragma mark - setter overides

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
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearGameState
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateLevelNumKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateStreamSpeedKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateMeterScaleKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateAllTopicsKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateTrendsToRecirculateKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStateTrendsToFavoriteKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStatePlayerRankKey"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GameStatePlayerScoreKey"];
    
    // level num
    [[NSUserDefaults standardUserDefaults]setObject:levelNumDefault forKey:GAME_STATE_LEVEL_NUM_KEY];
    _levelNum = [levelNumDefault integerValue];
    
    // stream speed
    [[NSUserDefaults standardUserDefaults]setObject:streamSpeedDefault forKey:GAME_STATE_STREAM_SPEED_KEY];
    _streamSpeed = [streamSpeedDefault doubleValue];
    
    // meter scale
    [[NSUserDefaults standardUserDefaults]setObject:meterScaleDefault forKey:GAME_STATE_METER_SCALE_KEY];
    _meterScale = [meterScaleDefault doubleValue];
    
    // player rank
    [[NSUserDefaults standardUserDefaults]setObject:playerRankDefault forKey:GAME_STATE_PLAYER_RANK_KEY];
    _playerRank = [playerRankDefault integerValue];
    
    // player score
    [[NSUserDefaults standardUserDefaults]setObject:playerScoreDefault forKey:GAME_STATE_PLAYER_SCORE_KEY];
    _playerScore = [playerScoreDefault integerValue];
    
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
