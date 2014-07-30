//
//  LevelOverPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelOverPopup.h"
#import "GameState.h"

static const int MAX_NUM_LEVELS = 3;

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

- (void)setRecirculateLabel:(NSString *)labelText
{
    _recirculateLabel.string = labelText;
}

- (void)setFavoriteLabel:(NSString *)labelText
{
    _favoritesLabel.string = labelText;
}

# pragma  mark - Custom Methods

- (void)goToNextLevel
{
    CCLOG(@"goToNextLevel Pressed!");
    
    CCScene *nextScene;
    
    CCLOG(@"MAX_NUM_LEVELS + 1 = %i", (MAX_NUM_LEVELS + 1));
    
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
