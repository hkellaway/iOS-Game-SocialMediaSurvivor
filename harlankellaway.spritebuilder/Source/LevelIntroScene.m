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
#import "Utilities.h"

@implementation LevelIntroScene
{
    CCLabelTTF *_levelLabel;
    CCNode *_levelIntroTrendsBox;
    
    NSMutableArray *_allTopics;
    NSMutableSet *_usedTopics;
    int numToRecirculate;
    int numToFavorite;
}

- (void)didLoadFromCCB
{
    int levelNum = [GameState sharedInstance].levelNum;

    _allTopics = [NSMutableArray array];
    _usedTopics = [NSMutableSet set];
    
    NSArray *levelsArray = [Utilities sharedInstance].levelsArray;
    numToRecirculate = [[levelsArray[levelNum - 1] objectForKey:@"NumTopicsToRecirculate"] intValue];
    numToFavorite = [[levelsArray[levelNum - 1] objectForKey:@"NumTopicsToFavorite"] intValue];
    
    // read in current Level and set Scene title
    _levelLabel.string = [NSString stringWithFormat:@"Day %d", [GameState sharedInstance].levelNum];
    
    NSMutableArray *tempTopics = [[NSMutableArray alloc] init];
    
    // generate Trend objects to global GameState Topics array
    for(int j = 0; j < numToRecirculate; j++)
    {
        // get random topic
        NSString *randomTopic = [self getRandomTopic];
        
        // if topic already used, find another topic
        while([_usedTopics containsObject:randomTopic])
        {
            randomTopic = [self getRandomTopic];
        }
        
        [_usedTopics addObject:randomTopic];
        [tempTopics addObject:randomTopic];
    }
    
    // store topics in GameState
    [[GameState sharedInstance] setTrendsToRecirculate:tempTopics];
    
    tempTopics = [[NSMutableArray alloc] init];
    
    for(int k = 0; k < numToFavorite; k++)
    {
        NSString *randomTopic = [self getRandomTopic];
        
        while([_usedTopics containsObject:randomTopic])
        {
            randomTopic = [self getRandomTopic];
        }
        
        [_usedTopics addObject:randomTopic];
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
        [trend setTrendText:[NSString stringWithFormat:@"%@", ((NSString *)trendsToFavorite[j]).capitalizedString]];
        [trend setTrendAction:[GameState sharedInstance].imageNameFavorite];
        [_levelIntroTrendsBox addChild:trend];
    }
    
    for(int i = 0; i < [trendsToRecirculate count]; i++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend setTrendText:[NSString stringWithFormat:@"%@", ((NSString *)trendsToRecirculate[i]).capitalizedString]];
        [trend setTrendAction:[GameState sharedInstance].imageNameRecirculate];
        [_levelIntroTrendsBox addChild:trend];
    }
}

# pragma mark - custom methods

- (void)startLevel
{
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

@end
