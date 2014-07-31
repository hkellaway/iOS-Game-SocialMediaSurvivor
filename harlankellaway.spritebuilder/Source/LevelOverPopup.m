//
//  LevelOverPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelOverPopup.h"
#import "GameState.h"

static const int MAX_NUM_LEVELS = 6;

@implementation LevelOverPopup
{
    CCButton *_goToNextLevel;
    CCLayoutBox *_levelOverStatsBox;
    CCLabelTTF *_levelOverLabel;
    
    CCLabelTTF *_recirculateLabel;
    CCLabelTTF *_favoritesLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
}


- (void)didLoadFromCCB
{
    self.visible = FALSE;
}

# pragma mark - Instance Methods

- (void)setVisible:(BOOL)visible
{
    if(visible)
    {
        // set content of Level Over node
        _levelOverLabel.string = [NSString stringWithFormat:@"Day %d Recap", [GameState sharedInstance].levelNum];
    }
    
    [super setVisible:visible];
}

# pragma mark - Instance Methods

- (void)updateRankLabel
{
    //TODO: retrieve Rank Name from Ranks plist
    _rankLabel.string = [NSString stringWithFormat:@"Rank: %i", [GameState sharedInstance].playerRank];
}

- (void)updateRecirculateLabel:(int)numRecirculated
{
    _recirculateLabel.string = [NSString stringWithFormat:@"Number recirculated: %i", numRecirculated];
}

- (void)updateFavoriteLabel:(int)numFavorited
{
    _favoritesLabel.string = [NSString stringWithFormat:@"Number favorited: %i", numFavorited];
}

# pragma  mark - Custom Methods

- (void)goToNextLevel
{
    CCScene *nextScene;
    
    // if max number of levels not reached, continue
    if([GameState sharedInstance].levelNum == (MAX_NUM_LEVELS + 1))
    {
        nextScene = [CCBReader loadAsScene:@"GameOverScene"];
    }
    else
    {
        nextScene = [CCBReader loadAsScene:@"LevelIntroScene"];
    }
    
    [[CCDirector sharedDirector] replaceScene:nextScene];
}

@end
