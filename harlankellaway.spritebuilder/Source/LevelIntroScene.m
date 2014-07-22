//
//  LevelIntroScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelIntroScene.h"
#import "GameState.h"
#import "Trend.h"

// TODO: make this number larger than the largest amount that will fit on the tallest device
static const int NUM_STATUSES = 13;

static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;
static const CGFloat TREND_SCALE_FACTOR = 0.65;

@implementation LevelIntroScene
{
    CCLabelTTF *_levelLabel;
    CCNode *_levelIntroTrendsBox;
    
    NSMutableArray *_allTopics;
    int numToRecirculate;
    int numToFavorite;
}

- (void)didLoadFromCCB
{
    // initialize variables
    _allTopics = [NSMutableArray array];
    numToRecirculate = NUM_STATUSES * PERCENTAGE_STATUS_TO_RECIRCULATE;
    numToFavorite = NUM_STATUSES * PERCENTAGE_STATUS_TO_FAVORITE;
    
    // read in current Level and set Scene title
    _levelLabel.string = [NSString stringWithFormat:@"Day %d", [GameState sharedInstance].levelNum];
    
//    // load Topics from p-list
//    NSString *errorDesc = nil;
//    NSPropertyListFormat format;
//    NSData *plistXML = [self getPListXML:@"Topics"];
//    
//    // convert static property list into corresponding property-list objects
//    // Topics p-list contains array of dictionarys
//    NSArray *topicsArray = (NSArray *)[NSPropertyListSerialization
//                                       propertyListFromData:plistXML
//                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
//                                       format:&format
//                                       errorDescription:&errorDesc];
//    if(!topicsArray)
//    {
//        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
//    }
//
//    // TODO: DON'T LOAD IN ALL TOPICS EACH TIME LEVEL LOADS
//    for(int i = 0; i < [topicsArray count]; i++)
//    {
//        [ addObject:[(NSDictionary *)topicsArray[i] objectForKey:@"Noun"]];
//    }
    
    NSMutableArray *tempTopics = [[NSMutableArray alloc] init];
    
    // generate Trend objects to global GameState Topics array
    for(int j = 0; j < numToRecirculate; j++)
    {
        // get random topic
        NSString *randomTopic = [self getRandomTopic];
        
        [tempTopics addObject:randomTopic];
    }
    
    // store topics in GameState
    [[GameState sharedInstance] setTrendsToRecirculate:tempTopics];
    
    tempTopics = [[NSMutableArray alloc] init];
    
    for(int k = 0; k < numToFavorite; k++)
    {
        NSString *randomTopic = [self getRandomTopic];
        
        [tempTopics addObject:randomTopic];
    }
    
    // store topics in GameState
    [[GameState sharedInstance] setTrendsToFavorite:tempTopics];
    
    // generate Trends
    NSMutableArray *trendsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
    NSMutableArray *trendsToFavorite = [GameState sharedInstance].trendsToFavorite;
    
    for(int j = 0; j < [trendsToFavorite count]; j++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend setTrendText:[NSString stringWithFormat:@"Favorite statuses on %@", ((NSString *)trendsToFavorite[j]).lowercaseString]];
        trend.scaleX = trend.scaleX * TREND_SCALE_FACTOR;
        trend.scaleY = trend.scaleY * TREND_SCALE_FACTOR;
        [_levelIntroTrendsBox addChild:trend];
    }
    
    for(int i = 0; i < [trendsToRecirculate count]; i++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend setTrendText:[NSString stringWithFormat:@"Recirculate statuses on %@", ((NSString *)trendsToRecirculate[i]).lowercaseString]];
        trend.scaleX = trend.scaleX * TREND_SCALE_FACTOR;
        trend.scaleY = trend.scaleY * TREND_SCALE_FACTOR;
        [_levelIntroTrendsBox addChild:trend];
    }
}

# pragma mark - custom methods

- (void)startLevel
{
    CCLOG(@"Level Start button pressed");
    
    // start Gameplay
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

# pragma mark - helper methods

- (NSString *)getRandomTopic
{
    NSMutableArray *allTopics = [GameState sharedInstance].allTopics;
    return allTopics[0 + arc4random() % ([allTopics count])];
}

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
