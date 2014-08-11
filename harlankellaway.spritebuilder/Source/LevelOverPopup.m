//
//  LevelOverPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelOverPopup.h"
#import "GameState.h"
#import "Utilities.h"

static const int MAX_NUM_LEVELS = 40;

@implementation LevelOverPopup
{
    CCButton *_goToNextLevel;
    CCLayoutBox *_levelOverStatsBox;
    CCLabelTTF *_levelOverLabel;
    
    CCLabelTTF *_recirculateLabel;
    CCLabelTTF *_favoritesLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highScoreLabel;
}


- (void)didLoadFromCCB
{
    _highScoreLabel.visible = FALSE;
    self.visible = FALSE;
}

# pragma mark - Instance Methods

- (void)setVisible:(BOOL)visible
{
    if(visible)
    {
        if(_gameplay.inbox.visible)
        {
            [_gameplay.inbox toggleVisibility];
        }
        
        // set content of Level Over node
        _levelOverLabel.string = [NSString stringWithFormat:@"Day %d", [GameState sharedInstance].levelNum];
    }
    
    [super setVisible:visible];
}

- (void)updateRankLabel
{
    // retreive Rank title from p-list and set
    NSArray *ranksArray = [Utilities sharedInstance].ranksArray;
    
    int numRanks = [ranksArray count];
    int rankNum = [GameState sharedInstance].playerRank;
    
    if(rankNum > numRanks) { rankNum = numRanks; }
    
    _rankLabel.string = [NSString stringWithFormat:@"%@", [ranksArray[rankNum] objectForKey:@"RankTitle"]];
}

-(void)updateScoreLabel
{
    int score = [GameState sharedInstance].playerScore;
    
    _scoreLabel.string = [NSString stringWithFormat:@"%i", score];
    
    if(score > [GameState sharedInstance].highScore)
    {
        _highScoreLabel.visible = TRUE;
    }
}

- (void)updateRecirculateLabel:(int)numRecirculated
{
    _recirculateLabel.string = [NSString stringWithFormat:@"%i", numRecirculated];
}

- (void)updateFavoriteLabel:(int)numFavorited
{
    _favoritesLabel.string = [NSString stringWithFormat:@"%i", numFavorited];
}

- (void)goToNextLevel
{
    // if max number of levels not reached, continue
    if([GameState sharedInstance].levelNum == (MAX_NUM_LEVELS) + 1)
    {
        [_gameplay gameOver];
    }
    else
    {
        [[Utilities sharedInstance] raiseVolume];
    
        CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
}

@end
