//
//  LevelIntroScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelIntroScene.h"
#import "Trend.h"
#import "CCTextureCache.h"
#import "Utilities.h"
#import "GameState.h"

@implementation LevelIntroScene
{
    // Declared in SpriteBuilder
    CCLabelTTF *_levelLabel;
    CCNode *_levelIntroRecirculateBox;
    CCNode *_levelIntroFavoriteBox;
    CCNode *_imageRecirculate;
    CCNode *_imageFavorite;
    //////////////////////////////
    
    NSMutableArray *_allTopics;
    NSMutableSet *_usedTopics;
    int _numToRecirculate;
    int _numToFavorite;
}

- (void)didLoadFromCCB
{
    int levelNum = [GameState sharedInstance].levelNum;
    
    _imageRecirculate.visible = FALSE;
    _imageFavorite.visible = FALSE;
    
    _allTopics = [NSMutableArray array];
    _usedTopics = [NSMutableSet set];
    
    NSArray *levelsArray = [Utilities sharedInstance].levelsArray;
    _numToRecirculate = [[levelsArray[levelNum - 1] objectForKey:@"NumTopicsToRecirculate"] intValue];
    _numToFavorite = [[levelsArray[levelNum - 1] objectForKey:@"NumTopicsToFavorite"] intValue];
    
    // read in current Level and set Scene title
    _levelLabel.string = [NSString stringWithFormat:@"Day %ld", (long)[GameState sharedInstance].levelNum];
    
    NSMutableArray *tempTopics = [[NSMutableArray alloc] init];
    
    // generate Trend objects to global GameState Topics array
    for(int j = 0; j < _numToRecirculate; j++)
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
    
    for(int k = 0; k < _numToFavorite; k++)
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
        [_levelIntroFavoriteBox addChild:trend];
    }
    
    for(int i = 0; i < [trendsToRecirculate count]; i++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend setTrendText:[NSString stringWithFormat:@"%@", ((NSString *)trendsToRecirculate[i]).capitalizedString]];
        [trend setTrendAction:[GameState sharedInstance].imageNameRecirculate];
        [_levelIntroRecirculateBox addChild:trend];
    }
    
    // add images
    if(_numToRecirculate > 0)
    {
        [_levelIntroRecirculateBox removeChild:_imageRecirculate];
        [_levelIntroRecirculateBox addChild:_imageRecirculate];
        _imageRecirculate.visible = TRUE;
    }
    
    if(_numToFavorite > 0)
    {
        [_levelIntroFavoriteBox removeChild:_imageFavorite];
        [_levelIntroFavoriteBox addChild:_imageFavorite];
        _imageFavorite.visible = TRUE;
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
