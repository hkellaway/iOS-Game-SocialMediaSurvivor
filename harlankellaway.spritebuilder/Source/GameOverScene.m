//
//  GameOverScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"
#import "GameState.h"
#import "Utilities.h"

@implementation GameOverScene
{
    // declared in SpriteBuilder
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highScoreLabel;
    CCButton * _twitterButton;
    CCButton *_facebookButton;
    ///////////////////////////
    
    long _score;
}

- (void)didLoadFromCCB
{
    _score = [GameState sharedInstance].playerScore;
    
    if([GameState sharedInstance].hasAchievedHighScore)
    {
        _highScoreLabel.visible = TRUE;
        
        // reset flag
        [GameState sharedInstance].hasAchievedHighScore = FALSE;
    }
    else
    {
        _highScoreLabel.visible = FALSE;
    }
    
    // update title label
    NSInteger levelNum = [GameState sharedInstance].levelNum;
    _gameOverLabel.string = ((levelNum == 2) ? [NSString stringWithFormat:@"You Survived %d Day", levelNum-1] : [NSString stringWithFormat:@"You Survived %d Days", levelNum-1]);
    
    // update score label
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[GameState sharedInstance].playerScore];
    
    // update rank label
    NSArray *ranksArray = [Utilities sharedInstance].ranksArray;
    
    NSUInteger numRanks = [ranksArray count];
    NSInteger rankNum = [GameState sharedInstance].playerRank;
    
    if(rankNum > numRanks) { rankNum = numRanks; }
    
    _rankLabel.string = [NSString stringWithFormat:@"%@", [ranksArray[rankNum] objectForKey:@"RankTitle"]];
    
    // social media
    if([MGWU isTwitterActive])
    {
        _twitterButton.enabled = TRUE;
    }
    else
    {
       _twitterButton.enabled = FALSE;
    }
    
    _facebookButton.enabled = FALSE;
}

- (void)restart
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark - Instance Methods

- (void)twitterSelected
{
    [MGWU postToTwitter:[NSString stringWithFormat:@"I'm winning at Social Media! Just got %li Followers in Social Media Survivor @SMSurvivorGame", _score]];
}

- (void)facebookSelected
{
    // to be implemented when Twitter added
}

@end
